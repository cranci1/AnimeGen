//
//  AnimeGenApp.swift
//  AnimeGen
//
//  Created by Francesco on 19/06/25.
//

import SwiftUI

@main
struct AnimeGenApp: App {
    @StateObject private var settings = Settings()
    @StateObject private var moduleManager = ModuleManager()
    @StateObject private var libraryManager = LibraryManager()
    @StateObject private var downloadManager = DownloadManager()
    @StateObject private var jsController = JSController.shared
    
    init() {
        if let userAccentColor = UserDefaults.standard.color(forKey: "accentColor") {
            UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = userAccentColor
        }
        clearTmpFolder()
        clearSoraFilesFromDocuments()
        
        TraktToken.checkAuthenticationStatus { isAuthenticated in
            if isAuthenticated {
                Logger.shared.log("Trakt authentication is valid")
            } else {
                Logger.shared.log("Trakt authentication required", type: "Error")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !UserDefaults.standard.bool(forKey: "hideSplashScreen") {
                    SplashScreenView()
                } else {
                    ContentView()
                }
            }
            .environment(\.layoutDirection, .leftToRight)
            .environmentObject(moduleManager)
            .environmentObject(settings)
            .environmentObject(libraryManager)
            .environmentObject(downloadManager)
            .environmentObject(jsController)
            .accentColor(settings.accentColor)
            .onAppear {
                settings.updateAppearance()
                Task {
                    if UserDefaults.standard.bool(forKey: "refreshModulesOnLaunch") {
                        await moduleManager.refreshModules()
                    }
                }
            }
            .onOpenURL { url in
                handleURL(url)
            }
        }
    }
    
    private func handleURL(_ url: URL) {
        guard url.scheme == "sora", let host = url.host else { return }
        switch host {
        case "default_page":
            if let comps = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let libraryURL = comps.queryItems?.first(where: { $0.name == "url" })?.value {
                
                UserDefaults.standard.set(libraryURL, forKey: "lastCommunityURL")
                UserDefaults.standard.set(true, forKey: "didReceiveDefaultPageLink")
                
                DropManager.shared.showDrop(
                    title: "Module Library Added",
                    subtitle: "You can browse the community library in settings.",
                    duration: 2,
                    icon: UIImage(systemName: "books.vertical.circle.fill")
                )
            }
            
        case "module":
            guard url.scheme == "sora",
                  url.host == "module",
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                  let moduleURL = components.queryItems?.first(where: { $0.name == "url" })?.value
            else {
                return
            }
            
            let addModuleView = ModuleAdditionSettingsView(moduleUrl: moduleURL).environmentObject(moduleManager)
            let hostingController = UIHostingController(rootView: addModuleView)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController?.present(hostingController, animated: true)
            } else {
                Logger.shared.log(
                    "Failed to present module addition view: No window scene found",
                    type: "Error"
                )
            }
            
        default:
            break
        }
    }
    
    private func clearTmpFolder() {
        let fileManager = FileManager.default
        let tmpDirectory = NSTemporaryDirectory()
        
        do {
            let tmpURL = URL(fileURLWithPath: tmpDirectory)
            let tmpContents = try fileManager.contentsOfDirectory(at: tmpURL, includingPropertiesForKeys: nil)
            
            for url in tmpContents {
                try fileManager.removeItem(at: url)
            }
            
            let parentURL = tmpURL.deletingLastPathComponent()
            let parentContents = try fileManager.contentsOfDirectory(at: parentURL, includingPropertiesForKeys: [.isDirectoryKey])
            for url in parentContents {
                if url.lastPathComponent.hasPrefix("com.apple.UserManagedAssets") {
                    var isDir: ObjCBool = false
                    if fileManager.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
                        try fileManager.removeItem(at: url)
                    }
                }
            }
        } catch {
            Logger.shared.log("Failed to clear tmp folder: \(error.localizedDescription)", type: "Error")
        }
    }
    
    private func clearSoraFilesFromDocuments() {
        let fileManager = FileManager.default
        
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            Logger.shared.log("Failed to get Documents directory path", type: "Error")
            return
        }
        
        do {
            let documentContents = try fileManager.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: [.isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
            
            let soraFiles = documentContents.filter { $0.pathExtension.lowercased() == "sora" }
            
            for soraFile in soraFiles {
                do {
                    try fileManager.removeItem(at: soraFile)
                    Logger.shared.log("Removed .sora file: \(soraFile.lastPathComponent)")
                } catch {
                    Logger.shared.log("Failed to remove .sora file \(soraFile.lastPathComponent): \(error.localizedDescription)", type: "Error")
                }
            }
            
            if !soraFiles.isEmpty {
                Logger.shared.log("Cleared \(soraFiles.count) .sora file(s) from Documents folder")
            }
            
        } catch {
            Logger.shared.log("Failed to scan Documents folder for .sora files: \(error.localizedDescription)", type: "Error")
        }
    }
}
