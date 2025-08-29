//
//  ModuleManager.swift
//  Sora
//
//  Created by Francesco on 26/01/25.
//

import Foundation
import SoraDecryption

@MainActor
class ModuleManager: ObservableObject {
    static let shared = ModuleManager()
    
    @Published var modules: [ScrapingModule] = []
    @Published var selectedModuleChanged = false
    
    private let fileManager = FileManager.default
    private let modulesFileName = "modules.json"
    
    // Encrypted modules setting - default to true (enabled)
    var encryptedModulesEnabled: Bool {
        UserDefaults.standard.object(forKey: "encryptedModulesEnabled") as? Bool ?? true
    }
    
    func setEncryptedModulesEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "encryptedModulesEnabled")
        Logger.shared.log("Encrypted modules \(enabled ? "enabled" : "disabled")", type: "Info")
        
        // Trigger a refresh of the modules list to update availability
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
    
    // Check if a module is available based on encryption settings
    func isModuleAvailable(_ module: ScrapingModule) -> Bool {
        let isEncrypted = module.metadata.encrypted ?? false
        if isEncrypted && !encryptedModulesEnabled {
            return false
        }
        return true
    }
    
    // Get only available modules based on encryption settings
    var availableModules: [ScrapingModule] {
        return modules.filter { isModuleAvailable($0) }
    }
    
    init() {
        let url = getModulesFilePath()
        if (!FileManager.default.fileExists(atPath: url.path)) {
            do {
                try "[]".write(to: url, atomically: true, encoding: .utf8)
                Logger.shared.log("Created empty modules file", type: "Info")
            } catch {
                Logger.shared.log("Failed to create modules file: \(error.localizedDescription)", type: "Error")
            }
        }
        loadModules()
        NotificationCenter.default.addObserver(self, selector: #selector(handleModulesSyncCompleted), name: .modulesSyncDidComplete, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleModulesSyncCompleted() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            let url = self.getModulesFilePath()
            guard FileManager.default.fileExists(atPath: url.path) else {
                Logger.shared.log("No modules file found after sync", type: "Error")
                self.modules = []
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decodedModules = try JSONDecoder().decode([ScrapingModule].self, from: data)
                self.modules = decodedModules
                
                Task {
                    await self.checkJSModuleFiles()
                }
                Logger.shared.log("Reloaded modules after iCloud sync")
            } catch {
                Logger.shared.log("Error handling modules sync: \(error.localizedDescription)", type: "Error")
                self.modules = []
            }
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func getModulesFilePath() -> URL {
        getDocumentsDirectory().appendingPathComponent(modulesFileName)
    }
    
    func loadModules() {
        let url = getModulesFilePath()
        
        guard FileManager.default.fileExists(atPath: url.path) else {
            Logger.shared.log("Modules file does not exist, creating empty one", type: "Info")
            do {
                try "[]".write(to: url, atomically: true, encoding: .utf8)
                modules = []
            } catch {
                Logger.shared.log("Failed to create modules file: \(error.localizedDescription)", type: "Error")
                modules = []
            }
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            do {
                let decodedModules = try JSONDecoder().decode([ScrapingModule].self, from: data)
                modules = decodedModules
                
                Task {
                    await checkJSModuleFiles()
                }
            } catch {
                Logger.shared.log("Failed to decode modules: \(error.localizedDescription)", type: "Error")
                try "[]".write(to: url, atomically: true, encoding: .utf8)
                modules = []
            }
        } catch {
            Logger.shared.log("Failed to load modules file: \(error.localizedDescription)", type: "Error")
            modules = []
        }
    }
    
    func checkJSModuleFiles() async {
        Logger.shared.log("Checking module files...", type: "Info")
        var missingCount = 0
        
        for module in modules {
            let localUrl = getDocumentsDirectory().appendingPathComponent(module.localPath)
            if !fileManager.fileExists(atPath: localUrl.path) {
                missingCount += 1
                do {
                    guard let scriptUrl = URL(string: module.metadata.scriptUrl) else {
                        Logger.shared.log("Invalid script URL for module: \(module.metadata.sourceName)", type: "Error")
                        continue
                    }
                    
                    let isEncrypted = module.metadata.encrypted ?? false
                    Logger.shared.log("Downloading missing module file for: \(module.metadata.sourceName) (encrypted: \(isEncrypted))", type: "Info")
                    
                    let (scriptData, _) = try await URLSession.custom.data(from: scriptUrl)
                    
                    if isEncrypted {
                        // For encrypted modules, save the raw data directly
                        try scriptData.write(to: localUrl)
                        Logger.shared.log("Successfully downloaded encrypted module file for: \(module.metadata.sourceName)")
                    } else {
                        // For non-encrypted modules, convert to string and save
                        guard let jsContent = String(data: scriptData, encoding: .utf8) else {
                            Logger.shared.log("Invalid script encoding for module: \(module.metadata.sourceName)", type: "Error")
                            continue
                        }
                        try jsContent.write(to: localUrl, atomically: true, encoding: .utf8)
                        Logger.shared.log("Successfully downloaded module file for: \(module.metadata.sourceName)")
                    }
                } catch {
                    Logger.shared.log("Failed to download module file for: \(module.metadata.sourceName) - \(error.localizedDescription)", type: "Error")
                }
            }
        }
        
        if missingCount > 0 {
            Logger.shared.log("Downloaded \(missingCount) missing module files", type: "Info")
        } else {
            Logger.shared.log("All module files are present", type: "Info")
        }
    }
    
    private func saveModules() {
        DispatchQueue.main.async {
            let url = self.getModulesFilePath()
            guard let data = try? JSONEncoder().encode(self.modules) else { return }
            try? data.write(to: url)
        }
    }
    
    func addModule(metadataUrl: String) async throws -> ScrapingModule {
        guard let url = URL(string: metadataUrl) else {
            throw NSError(domain: "Invalid metadata URL", code: -1)
        }
        
        if modules.contains(where: { $0.metadataUrl == metadataUrl }) {
            throw NSError(domain: "Module already exists", code: -1)
        }
        
        let (metadataData, _) = try await URLSession.custom.data(from: url)
        let metadata = try JSONDecoder().decode(ModuleMetadata.self, from: metadataData)
        
        guard let scriptUrl = URL(string: metadata.scriptUrl) else {
            throw NSError(domain: "Invalid script URL", code: -1)
        }
        
        let (scriptData, _) = try await URLSession.custom.data(from: scriptUrl)
        
        // Determine file extension based on encrypted flag
        let isEncrypted = metadata.encrypted ?? false
        let fileExtension = isEncrypted ? "sora" : "js"
        let fileName = "\(UUID().uuidString).\(fileExtension)"
        let localUrl = getDocumentsDirectory().appendingPathComponent(fileName)
        
        if isEncrypted {
            // For encrypted modules, save the raw binary data
            try scriptData.write(to: localUrl)
            Logger.shared.log("Saved encrypted module: \(metadata.sourceName)")
        } else {
            // For non-encrypted modules, convert to string and save
            guard let jsContent = String(data: scriptData, encoding: .utf8) else {
                throw NSError(domain: "Invalid script encoding", code: -1)
            }
            try jsContent.write(to: localUrl, atomically: true, encoding: .utf8)
            Logger.shared.log("Saved unencrypted module: \(metadata.sourceName)")
        }
        
        let module = ScrapingModule(
            metadata: metadata,
            localPath: fileName,
            metadataUrl: metadataUrl
        )
        
        DispatchQueue.main.async {
            self.modules.append(module)
            self.saveModules()
            self.selectedModuleChanged = true
            Logger.shared.log("Added module: \(module.metadata.sourceName) (encrypted: \(isEncrypted))")
        }
        
        return module
    }
    
    func deleteModule(_ module: ScrapingModule) {
        let localUrl = getDocumentsDirectory().appendingPathComponent(module.localPath)
        try? fileManager.removeItem(at: localUrl)
        
        modules.removeAll { $0.id == module.id }
        saveModules()
        Logger.shared.log("Deleted module: \(module.metadata.sourceName)")
        
        NotificationCenter.default.post(name: .moduleRemoved, object: module.id.uuidString)
    }
    
    func getModuleContent(_ module: ScrapingModule) throws -> String {
        let localUrl = getDocumentsDirectory().appendingPathComponent(module.localPath)
        
        guard FileManager.default.fileExists(atPath: localUrl.path) else {
            Logger.shared.log("Module file not found at path: \(localUrl.path)", type: "Error")
            throw NSError(domain: "Module file not found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Module file not found at \(localUrl.path)"])
        }
        
        let isEncrypted = module.metadata.encrypted ?? false
        Logger.shared.log("Loading module content for: \(module.metadata.sourceName) (encrypted: \(isEncrypted))", type: "Info")
        
        if isEncrypted {
            // Check if encrypted modules are enabled
            guard encryptedModulesEnabled else {
                Logger.shared.log("Encrypted modules are disabled, cannot load: \(module.metadata.sourceName)", type: "Error")
                throw NSError(domain: "Encrypted modules disabled", code: -1, userInfo: [NSLocalizedDescriptionKey: "Encrypted modules are disabled in settings"])
            }
            
            Logger.shared.log("Attempting to decrypt module: \(module.metadata.sourceName)", type: "Info")
            do {
                let encryptedData = try Data(contentsOf: localUrl)
                Logger.shared.log("Loaded encrypted data, size: \(encryptedData.count) bytes", type: "Info")
                
                guard let decryptedContent = SoraDecryption.decryptToString(data: encryptedData) else {
                    Logger.shared.log("SoraDecryption.decryptToString returned nil for module: \(module.metadata.sourceName)", type: "Error")
                    throw NSError(domain: "Failed to decrypt module content", code: -1, userInfo: [NSLocalizedDescriptionKey: "Decryption returned nil"])
                }
                
                Logger.shared.log("Successfully decrypted module: \(module.metadata.sourceName), content length: \(decryptedContent.count)", type: "Info")
                return decryptedContent
            } catch {
                Logger.shared.log("Failed to decrypt module: \(module.metadata.sourceName) - \(error.localizedDescription)", type: "Error")
                throw NSError(domain: "Failed to decrypt module content", code: -1, userInfo: [NSLocalizedDescriptionKey: error.localizedDescription])
            }
        } else {
            Logger.shared.log("Loading unencrypted module: \(module.metadata.sourceName)", type: "Info")
            do {
                let rawContent = try String(contentsOf: localUrl, encoding: .utf8)
                Logger.shared.log("Successfully loaded unencrypted module: \(module.metadata.sourceName), content length: \(rawContent.count)", type: "Info")
                return rawContent
            } catch {
                Logger.shared.log("Failed to load unencrypted module: \(module.metadata.sourceName) - \(error.localizedDescription)", type: "Error")
                throw error
            }
        }
    }
    
    func refreshModules() async {
        let modulesCopy = modules
        var updatedModules: [(Int, ScrapingModule)] = []
        
        for (index, module) in modulesCopy.enumerated() {
            do {
                guard let metadataUrl = URL(string: module.metadataUrl) else {
                    Logger.shared.log("Invalid metadata URL for module: \(module.metadata.sourceName)", type: "Error")
                    continue
                }
                
                let (metadataData, _) = try await URLSession.custom.data(from: metadataUrl)
                let newMetadata = try JSONDecoder().decode(ModuleMetadata.self, from: metadataData)
                
                if newMetadata.version != module.metadata.version {
                    guard let scriptUrl = URL(string: newMetadata.scriptUrl) else {
                        throw NSError(domain: "Invalid script URL", code: -1)
                    }
                    
                    let (scriptData, _) = try await URLSession.custom.data(from: scriptUrl)
                    
                    // Check if encryption status changed
                    let oldIsEncrypted = module.metadata.encrypted ?? false
                    let newIsEncrypted = newMetadata.encrypted ?? false
                    
                    var newLocalPath = module.localPath
                    
                    // If encryption status changed, create new file with correct extension
                    if oldIsEncrypted != newIsEncrypted {
                        // Delete old file
                        let oldLocalUrl = getDocumentsDirectory().appendingPathComponent(module.localPath)
                        try? fileManager.removeItem(at: oldLocalUrl)
                        
                        // Create new file with correct extension
                        let fileExtension = newIsEncrypted ? "sora" : "js"
                        let fileName = "\(module.id.uuidString).\(fileExtension)"
                        newLocalPath = fileName
                    }
                    
                    let localUrl = getDocumentsDirectory().appendingPathComponent(newLocalPath)
                    
                    if newIsEncrypted {
                        // For encrypted modules, save the raw binary data
                        try scriptData.write(to: localUrl)
                        Logger.shared.log("Updated encrypted module: \(module.metadata.sourceName)")
                    } else {
                        // For non-encrypted modules, convert to string and save
                        guard let jsContent = String(data: scriptData, encoding: .utf8) else {
                            throw NSError(domain: "Invalid script encoding", code: -1)
                        }
                        try jsContent.write(to: localUrl, atomically: true, encoding: .utf8)
                        Logger.shared.log("Updated unencrypted module: \(module.metadata.sourceName)")
                    }
                    
                    let updatedModule = ScrapingModule(
                        id: module.id,
                        metadata: newMetadata,
                        localPath: newLocalPath,
                        metadataUrl: module.metadataUrl,
                        isActive: module.isActive
                    )
                    
                    updatedModules.append((index, updatedModule))
                    Logger.shared.log("Prepared update for module: \(module.metadata.sourceName) to version \(newMetadata.version) (encrypted: \(newIsEncrypted))")
                }
            } catch {
                Logger.shared.log("Failed to refresh module: \(module.metadata.sourceName) - \(error.localizedDescription)")
            }
        }
        
        if !updatedModules.isEmpty {
            for (index, updatedModule) in updatedModules {
                if index < modules.count {
                    modules[index] = updatedModule
                }
            }
            saveModules()
            Logger.shared.log("Successfully updated \(updatedModules.count) modules")
        }
    }
}
