//
//  JSController-Novel.swift
//  Sora
//
//  Created by paul on 20/06/25.
//

import Foundation
import JavaScriptCore

enum JSError: Error {
    case moduleNotFound
    case invalidResponse
    case emptyContent
    case redirectError
    case jsException(String)
    
    var localizedDescription: String {
        switch self {
        case .moduleNotFound:
            return "Module not found"
        case .invalidResponse:
            return "Invalid response from server"
        case .emptyContent:
            return "No content received"
        case .redirectError:
            return "Redirect error occurred"
        case .jsException(let message):
            return "JavaScript error: \(message)"
        }
    }
}

extension JSController {
    @MainActor func extractChapters(moduleId: UUID, href: String, completion: @escaping ([[String: Any]]) -> Void) {
        guard ModuleManager().modules.first(where: { $0.id == moduleId }) != nil else {
            Logger.shared.log("Module not found for ID: \(moduleId)", type: "Error")
            completion([])
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                completion([])
                return
            }
            
            guard let extractChaptersFunction = self.context.objectForKeyedSubscript("extractChapters") else {
                Logger.shared.log("extractChapters: function not found", type: "Error")
                completion([])
                return
            }
            
            let result = extractChaptersFunction.call(withArguments: [href])
            if result?.isUndefined == true || result == nil {
                Logger.shared.log("extractChapters: result is undefined or nil", type: "Error")
                completion([])
                return
            }
            
            if let result = result, result.hasProperty("then") {
                let group = DispatchGroup()
                group.enter()
                var chaptersArr: [[String: Any]] = []
                var hasLeftGroup = false
                let groupQueue = DispatchQueue(label: "extractChapters.group")
                
                let thenBlock: @convention(block) (JSValue) -> Void = { jsValue in
                    Logger.shared.log("extractChapters thenBlock: \(jsValue)", type: "Debug")
                    groupQueue.sync {
                        guard !hasLeftGroup else {
                            Logger.shared.log("extractChapters: thenBlock called but group already left", type: "Debug")
                            return
                        }
                        hasLeftGroup = true
                        
                        if let arr = jsValue.toArray() as? [[String: Any]] {
                            Logger.shared.log("extractChapters: parsed as array, count = \(arr.count)", type: "Debug")
                            chaptersArr = arr
                        } else if let jsonString = jsValue.toString(), let data = jsonString.data(using: .utf8) {
                            do {
                                if let arr = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                                    Logger.shared.log("extractChapters: parsed as JSON string, count = \(arr.count)", type: "Debug")
                                    chaptersArr = arr
                                } else {
                                    Logger.shared.log("extractChapters: JSON string did not parse to array", type: "Error")
                                }
                            } catch {
                                Logger.shared.log("JSON parsing error of extractChapters: \(error)", type: "Error")
                            }
                        } else {
                            Logger.shared.log("extractChapters: could not parse result", type: "Error")
                        }
                        group.leave()
                    }
                }
                let catchBlock: @convention(block) (JSValue) -> Void = { jsValue in
                    Logger.shared.log("extractChapters catchBlock: \(jsValue)", type: "Error")
                    groupQueue.sync {
                        guard !hasLeftGroup else {
                            Logger.shared.log("extractChapters: catchBlock called but group already left", type: "Debug")
                            return
                        }
                        hasLeftGroup = true
                        group.leave()
                    }
                }
                result.invokeMethod("then", withArguments: [thenBlock])
                result.invokeMethod("catch", withArguments: [catchBlock])
                group.notify(queue: .main) {
                    completion(chaptersArr)
                }
            } else {
                if let arr = result?.toArray() as? [[String: Any]] {
                    Logger.shared.log("extractChapters: direct array, count = \(arr.count)", type: "Debug")
                    completion(arr)
                } else if let jsonString = result?.toString(), let data = jsonString.data(using: .utf8) {
                    do {
                        if let arr = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                            Logger.shared.log("extractChapters: direct JSON string, count = \(arr.count)", type: "Debug")
                            completion(arr)
                        } else {
                            Logger.shared.log("extractChapters: direct JSON string did not parse to array", type: "Error")
                            completion([])
                        }
                    } catch {
                        Logger.shared.log("JSON parsing error of extractChapters: \(error)", type: "Error")
                        completion([])
                    }
                } else {
                    Logger.shared.log("extractChapters: could not parse direct result", type: "Error")
                    completion([])
                }
            }
        }
    }
    
    @MainActor func extractText(moduleId: UUID, href: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let module = ModuleManager().modules.first(where: { $0.id == moduleId }) else {
            completion(.failure(JSError.moduleNotFound))
            return
        }
        
        let workItem = DispatchWorkItem { [weak self] in
            guard let self = self else {
                completion(.failure(JSError.invalidResponse))
                return
            }
            
            if self.context.objectForKeyedSubscript("extractText") == nil {
                Logger.shared.log("extractText function not found, attempting to load module script", type: "Debug")
                do {
                    let moduleContent = try ModuleManager().getModuleContent(module)
                    self.loadScript(moduleContent)
                    Logger.shared.log("Successfully loaded module script", type: "Debug")
                } catch {
                    Logger.shared.log("Failed to load module script: \(error)", type: "Error")
                }
            }
            
            guard let function = self.context.objectForKeyedSubscript("extractText") else {
                Logger.shared.log("extractText function not available after loading module script", type: "Error")
                
                self.fetchContentDirectly(from: href) { result in
                    completion(result)
                }
                return
            }
            
            let result = function.call(withArguments: [href])
            
            if let exception = self.context.exception {
                Logger.shared.log("Error extracting text: \(exception)", type: "Error")
                
                self.fetchContentDirectly(from: href) { result in
                    completion(result)
                }
                return
            }
            
            if let result = result, result.hasProperty("then") {
                let group = DispatchGroup()
                group.enter()
                var extractedText = ""
                var extractError: Error? = nil
                var hasLeftGroup = false
                let groupQueue = DispatchQueue(label: "extractText.group")
                
                let thenBlock: @convention(block) (JSValue) -> Void = { jsValue in
                    Logger.shared.log("extractText thenBlock: received value", type: "Debug")
                    groupQueue.sync {
                        guard !hasLeftGroup else {
                            Logger.shared.log("extractText: thenBlock called but group already left", type: "Debug")
                            return
                        }
                        hasLeftGroup = true
                        
                        if let text = jsValue.toString(), !text.isEmpty {
                            Logger.shared.log("extractText: successfully extracted text", type: "Debug")
                            extractedText = text
                        } else {
                            extractError = JSError.emptyContent
                        }
                        group.leave()
                    }
                }
                
                let catchBlock: @convention(block) (JSValue) -> Void = { jsValue in
                    Logger.shared.log("extractText catchBlock: \(jsValue)", type: "Error")
                    groupQueue.sync {
                        guard !hasLeftGroup else {
                            Logger.shared.log("extractText: catchBlock called but group already left", type: "Debug")
                            return
                        }
                        hasLeftGroup = true
                        
                        if extractedText.isEmpty {
                            extractError = JSError.jsException(jsValue.toString() ?? "Unknown error")
                        }
                        group.leave()
                    }
                }
                
                result.invokeMethod("then", withArguments: [thenBlock])
                result.invokeMethod("catch", withArguments: [catchBlock])
                
                let notifyWorkItem = DispatchWorkItem {
                    if !extractedText.isEmpty {
                        completion(.success(extractedText))
                    } else if extractError != nil {
                        self.fetchContentDirectly(from: href) { result in
                            completion(result)
                        }
                    } else {
                        self.fetchContentDirectly(from: href) { result in
                            completion(result)
                        }
                    }
                }
                
                group.notify(queue: .main, work: notifyWorkItem)
            } else {
                if let text = result?.toString(), !text.isEmpty {
                    Logger.shared.log("extractText: direct string result", type: "Debug")
                    completion(.success(text))
                } else {
                    Logger.shared.log("extractText: could not parse direct result, trying direct fetch", type: "Error")
                    self.fetchContentDirectly(from: href) { result in
                        completion(result)
                    }
                }
            }
        }
        
        DispatchQueue.main.async(execute: workItem)
    }
    
    private func fetchContentDirectly(from url: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(JSError.invalidResponse))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1", forHTTPHeaderField: "User-Agent")
        
        Logger.shared.log("Attempting direct fetch from: \(url.absoluteString)", type: "Debug")
        
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    Logger.shared.log("Direct fetch error: \(error.localizedDescription)", type: "Error")
                    completion(.failure(JSError.invalidResponse))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    Logger.shared.log("Direct fetch failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)", type: "Error")
                    completion(.failure(JSError.invalidResponse))
                }
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async {
                    Logger.shared.log("Failed to decode response data", type: "Error")
                    completion(.failure(JSError.invalidResponse))
                }
                return
            }
            
            var content = ""
            
            if let contentRange = htmlString.range(of: "<article", options: .caseInsensitive),
               let endRange = htmlString.range(of: "</article>", options: .caseInsensitive) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from <article> tag", type: "Debug")
            } else if let contentRange = htmlString.range(of: "<div class=\"chapter-content\"", options: .caseInsensitive),
                      let endRange = htmlString.range(of: "</div>", options: .caseInsensitive, range: contentRange.upperBound..<htmlString.endIndex) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from chapter-content div", type: "Debug")
            } else if let contentRange = htmlString.range(of: "<div class=\"content\"", options: .caseInsensitive),
                      let endRange = htmlString.range(of: "</div>", options: .caseInsensitive, range: contentRange.upperBound..<htmlString.endIndex) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from content div", type: "Debug")
            } else if let contentRange = htmlString.range(of: "<div id=\"chapter-content\"", options: .caseInsensitive),
                      let endRange = htmlString.range(of: "</div>", options: .caseInsensitive, range: contentRange.upperBound..<htmlString.endIndex) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from chapter-content id div", type: "Debug")
            } else if let contentRange = htmlString.range(of: "<div class=\"chapter\"", options: .caseInsensitive),
                      let endRange = htmlString.range(of: "</div>", options: .caseInsensitive, range: contentRange.upperBound..<htmlString.endIndex) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from chapter div", type: "Debug")
            } else if let contentRange = htmlString.range(of: "<main", options: .caseInsensitive),
                      let endRange = htmlString.range(of: "</main>", options: .caseInsensitive) {
                let startIndex = contentRange.lowerBound
                let endIndex = endRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from <main> tag", type: "Debug")
            } else if let bodyRange = htmlString.range(of: "<body", options: .caseInsensitive),
                      let endBodyRange = htmlString.range(of: "</body>", options: .caseInsensitive) {
                let startIndex = bodyRange.lowerBound
                let endIndex = endBodyRange.upperBound
                content = String(htmlString[startIndex..<endIndex])
                Logger.shared.log("Extracted content from <body> tag", type: "Debug")
            } else {
                content = htmlString
                Logger.shared.log("Using full HTML content", type: "Debug")
            }
            
            content = cleanHTMLContent(content)
            
            DispatchQueue.main.async {
                Logger.shared.log("Direct fetch successful, content length: \(content.count)", type: "Debug")
                completion(.success(content))
            }
        }
        
        task.resume()
    }
    
    private func cleanHTMLContent(_ content: String) -> String {
        var cleaned = content
        
        cleaned = cleaned.replacingOccurrences(
            of: "<script[^>]*>.*?</script>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        cleaned = cleaned.replacingOccurrences(
            of: "<style[^>]*>.*?</style>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        cleaned = cleaned.replacingOccurrences(
            of: "<nav[^>]*>.*?</nav>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        cleaned = cleaned.replacingOccurrences(
            of: "<header[^>]*>.*?</header>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        cleaned = cleaned.replacingOccurrences(
            of: "<footer[^>]*>.*?</footer>",
            with: "",
            options: [.regularExpression, .caseInsensitive]
        )
        
        let unwantedClasses = ["advertisement", "ad", "ads", "sidebar", "menu", "navigation", "nav", "header", "footer", "comments", "comment"]
        for className in unwantedClasses {
            cleaned = cleaned.replacingOccurrences(
                of: "<div[^>]*class=\"[^\"]*\(className)[^\"]*\"[^>]*>.*?</div>",
                with: "",
                options: [.regularExpression, .caseInsensitive]
            )
        }
        
        cleaned = cleaned.replacingOccurrences(
            of: "\\s+",
            with: " ",
            options: .regularExpression
        )
        
        return cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
