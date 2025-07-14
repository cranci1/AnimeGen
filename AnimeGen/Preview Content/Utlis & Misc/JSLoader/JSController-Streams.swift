//
//  JSLoader-Streams.swift
//  Sulfur
//
//  Created by Francesco on 30/03/25.
//

import JavaScriptCore

extension JSController {
    
    func fetchStreamUrl(episodeUrl: String, softsub: Bool = false, module: ScrapingModule, completion: @escaping ((streams: [String]?, subtitles: [String]?, sources: [[String:Any]]? )) -> Void) {
        guard let url = URL(string: episodeUrl) else {
            completion((nil, nil,nil))
            return
        }
        
        URLSession.custom.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let error = error {
                Logger.shared.log("Network error: \(error)", type: "Error")
                DispatchQueue.main.async { completion((nil, nil,nil)) }
                return
            }
            
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                Logger.shared.log("Failed to decode HTML", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            Logger.shared.log(html, type: "HTMLStrings")
            
            guard let parseFunction = self.context.objectForKeyedSubscript("extractStreamUrl") else {
                Logger.shared.log("extractStreamUrl function not found in JavaScript context", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            let result = parseFunction.call(withArguments: [html])
            
            if let exception = self.context.exception {
                Logger.shared.log("JavaScript exception in extractStreamUrl: \(exception)", type: "Error")
                self.context.exception = nil
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            guard let result = result, !result.isNull, !result.isUndefined else {
                Logger.shared.log("extractStreamUrl returned null or undefined", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            guard let resultString = result.toString() else {
                Logger.shared.log("Failed to convert JavaScript result to string", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            if resultString == "[object Promise]" {
                Logger.shared.log("Received Promise object instead of resolved value, waiting for proper resolution", type: "Stream")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            if let data = resultString.data(using: .utf8) {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        var streamUrls: [String]? = nil
                        var subtitleUrls: [String]? = nil
                        var streamUrlsAndHeaders : [[String:Any]]? = nil
                        
                        if let streamSources = json["streams"] as? [[String:Any]] {
                            streamUrlsAndHeaders = streamSources
                            Logger.shared.log("Found \(streamSources.count) streams and headers", type: "Stream")
                        } else if let streamSource = json["stream"] as? [String:Any] {
                            streamUrlsAndHeaders = [streamSource]
                            Logger.shared.log("Found single stream with headers", type: "Stream")
                        } else if let streamsArray = json["streams"] as? [String] {
                            streamUrls = streamsArray
                            Logger.shared.log("Found \(streamsArray.count) streams", type: "Stream")
                        } else if let streamUrl = json["stream"] as? String {
                            streamUrls = [streamUrl]
                            Logger.shared.log("Found single stream", type: "Stream")
                        }
                        
                        if let subsArray = json["subtitles"] as? [String] {
                            subtitleUrls = subsArray
                            Logger.shared.log("Found \(subsArray.count) subtitle tracks", type: "Stream")
                        } else if let subtitleUrl = json["subtitles"] as? String {
                            subtitleUrls = [subtitleUrl]
                            Logger.shared.log("Found single subtitle track", type: "Stream")
                        }
                        
                        Logger.shared.log("Starting stream with \(streamUrls?.count ?? 0) sources and \(subtitleUrls?.count ?? 0) subtitles", type: "Stream")
                        DispatchQueue.main.async {
                            completion((streamUrls, subtitleUrls, streamUrlsAndHeaders))
                        }
                        return
                    }
                    
                    if let streamsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                        Logger.shared.log("Starting multi-stream with \(streamsArray.count) sources", type: "Stream")
                        DispatchQueue.main.async { completion((streamsArray, nil, nil)) }
                        return
                    }
                } catch {
                    Logger.shared.log("JSON parsing error: \(error.localizedDescription)", type: "Error")
                }
            }
            
            Logger.shared.log("Starting stream from: \(resultString)", type: "Stream")
            DispatchQueue.main.async {
                completion(([resultString], nil, nil))
            }
        }.resume()
    }
    
    func fetchStreamUrlJS(episodeUrl: String, softsub: Bool = false, module: ScrapingModule, completion: @escaping ((streams: [String]?, subtitles: [String]?,sources: [[String:Any]]? )) -> Void) {
        if let exception = context.exception {
            Logger.shared.log("JavaScript exception: \(exception)", type: "Error")
            completion((nil, nil,nil))
            return
        }
        
        guard let extractStreamUrlFunction = context.objectForKeyedSubscript("extractStreamUrl") else {
            Logger.shared.log("No JavaScript function extractStreamUrl found", type: "Error")
            completion((nil, nil,nil))
            return
        }
        
        let promiseValue = extractStreamUrlFunction.call(withArguments: [episodeUrl])
        guard let promise = promiseValue else {
            Logger.shared.log("extractStreamUrl did not return a Promise", type: "Error")
            completion((nil, nil,nil))
            return
        }
        
        let thenBlock: @convention(block) (JSValue) -> Void = { [weak self] result in
            guard self != nil else { return }
            
            if result.isNull || result.isUndefined {
                Logger.shared.log("Received null or undefined result from JavaScript", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            if let resultString = result.toString(), resultString == "[object Promise]" {
                Logger.shared.log("Received Promise object instead of resolved value, waiting for proper resolution", type: "Stream")
                return
            }
            
            guard let jsonString = result.toString() else {
                Logger.shared.log("Failed to convert JSValue to string", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            guard let data = jsonString.data(using: .utf8) else {
                Logger.shared.log("Failed to convert string to data", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    var streamUrls: [String]? = nil
                    var subtitleUrls: [String]? = nil
                    var streamUrlsAndHeaders : [[String:Any]]? = nil
                    
                    if let streamSources = json["streams"] as? [[String:Any]] {
                        streamUrlsAndHeaders = streamSources
                        Logger.shared.log("Found \(streamSources.count) streams and headers", type: "Stream")
                    } else if let streamSource = json["stream"] as? [String:Any] {
                        streamUrlsAndHeaders = [streamSource]
                        Logger.shared.log("Found single stream with headers", type: "Stream")
                    } else if let streamsArray = json["streams"] as? [String] {
                        streamUrls = streamsArray
                        Logger.shared.log("Found \(streamsArray.count) streams", type: "Stream")
                    } else if let streamUrl = json["stream"] as? String {
                        streamUrls = [streamUrl]
                        Logger.shared.log("Found single stream", type: "Stream")
                    }
                    
                    if let subsArray = json["subtitles"] as? [String] {
                        subtitleUrls = subsArray
                        Logger.shared.log("Found \(subsArray.count) subtitle tracks", type: "Stream")
                    } else if let subtitleUrl = json["subtitles"] as? String {
                        subtitleUrls = [subtitleUrl]
                        Logger.shared.log("Found single subtitle track", type: "Stream")
                    }
                    
                    Logger.shared.log("Starting stream with \(streamUrls?.count ?? 0) sources and \(subtitleUrls?.count ?? 0) subtitles", type: "Stream")
                    DispatchQueue.main.async {
                        completion((streamUrls, subtitleUrls, streamUrlsAndHeaders))
                    }
                    return
                }
                
                if let streamsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    Logger.shared.log("Starting multi-stream with \(streamsArray.count) sources", type: "Stream")
                    DispatchQueue.main.async { completion((streamsArray, nil, nil)) }
                    return
                }
            } catch {
                Logger.shared.log("JSON parsing error: \(error.localizedDescription)", type: "Error")
            }
            
            Logger.shared.log("Starting stream from: \(jsonString)", type: "Stream")
            DispatchQueue.main.async {
                completion(([jsonString], nil, nil))
            }
        }
        
        let catchBlock: @convention(block) (JSValue) -> Void = { error in
            let errorMessage = error.toString() ?? "Unknown JavaScript error"
            Logger.shared.log("Promise rejected: \(errorMessage)", type: "Error")
            DispatchQueue.main.async {
                completion((nil, nil, nil))
            }
        }
        
        let thenFunction = JSValue(object: thenBlock, in: context)
        let catchFunction = JSValue(object: catchBlock, in: context)
        
        guard let thenFunction = thenFunction, let catchFunction = catchFunction else {
            Logger.shared.log("Failed to create JSValue objects for Promise handling", type: "Error")
            completion((nil, nil, nil))
            return
        }
        
        promise.invokeMethod("then", withArguments: [thenFunction])
        promise.invokeMethod("catch", withArguments: [catchFunction])
    }
    
    func fetchStreamUrlJSSecond(episodeUrl: String, softsub: Bool = false, module: ScrapingModule, completion: @escaping ((streams: [String]?, subtitles: [String]?,sources: [[String:Any]]? )) -> Void) {
        let url = URL(string: episodeUrl)!
        let task = URLSession.custom.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                Logger.shared.log("URLSession error: \(error.localizedDescription)", type: "Error")
                DispatchQueue.main.async { completion((nil, nil,nil)) }
                return
            }
            
            guard let data = data, let htmlString = String(data: data, encoding: .utf8) else {
                Logger.shared.log("Failed to fetch HTML data", type: "Error")
                DispatchQueue.main.async { completion((nil, nil, nil)) }
                return
            }
            
            DispatchQueue.main.async {
                if let exception = self.context.exception {
                    Logger.shared.log("JavaScript exception: \(exception)", type: "Error")
                    completion((nil, nil, nil))
                    return
                }
                
                guard let extractStreamUrlFunction = self.context.objectForKeyedSubscript("extractStreamUrl") else {
                    Logger.shared.log("No JavaScript function extractStreamUrl found", type: "Error")
                    completion((nil, nil, nil))
                    return
                }
                
                let promiseValue = extractStreamUrlFunction.call(withArguments: [htmlString])
                guard let promise = promiseValue else {
                    Logger.shared.log("extractStreamUrl did not return a Promise", type: "Error")
                    completion((nil, nil, nil))
                    return
                }
                
                let thenBlock: @convention(block) (JSValue) -> Void = { [weak self] result in
                    guard self != nil else { return }
                    
                    if result.isNull || result.isUndefined {
                        Logger.shared.log("Received null or undefined result from JavaScript", type: "Error")
                        DispatchQueue.main.async { completion((nil, nil, nil)) }
                        return
                    }
                    
                    if let resultString = result.toString(), resultString == "[object Promise]" {
                        Logger.shared.log("Received Promise object instead of resolved value, waiting for proper resolution", type: "Stream")
                        return
                    }
                    
                    guard let jsonString = result.toString() else {
                        Logger.shared.log("Failed to convert JSValue to string", type: "Error")
                        DispatchQueue.main.async { completion((nil, nil, nil)) }
                        return
                    }
                    
                    guard let data = jsonString.data(using: .utf8) else {
                        Logger.shared.log("Failed to convert string to data", type: "Error")
                        DispatchQueue.main.async { completion((nil, nil, nil)) }
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            var streamUrls: [String]? = nil
                            var subtitleUrls: [String]? = nil
                            var streamUrlsAndHeaders : [[String:Any]]? = nil
                            
                            if let streamSources = json["streams"] as? [[String:Any]] {
                                streamUrlsAndHeaders = streamSources
                                Logger.shared.log("Found \(streamSources.count) streams and headers", type: "Stream")
                            } else if let streamSource = json["stream"] as? [String:Any] {
                                streamUrlsAndHeaders = [streamSource]
                                Logger.shared.log("Found single stream with headers", type: "Stream")
                            } else if let streamsArray = json["streams"] as? [String] {
                                streamUrls = streamsArray
                                Logger.shared.log("Found \(streamsArray.count) streams", type: "Stream")
                            } else if let streamUrl = json["stream"] as? String {
                                streamUrls = [streamUrl]
                                Logger.shared.log("Found single stream", type: "Stream")
                            }
                            
                            if let subsArray = json["subtitles"] as? [String] {
                                subtitleUrls = subsArray
                                Logger.shared.log("Found \(subsArray.count) subtitle tracks", type: "Stream")
                            } else if let subtitleUrl = json["subtitles"] as? String {
                                subtitleUrls = [subtitleUrl]
                                Logger.shared.log("Found single subtitle track", type: "Stream")
                            }
                            
                            Logger.shared.log("Starting stream with \(streamUrls?.count ?? 0) sources and \(subtitleUrls?.count ?? 0) subtitles", type: "Stream")
                            DispatchQueue.main.async {
                                completion((streamUrls, subtitleUrls, streamUrlsAndHeaders))
                            }
                            return
                        }
                        
                        if let streamsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                            Logger.shared.log("Starting multi-stream with \(streamsArray.count) sources", type: "Stream")
                            DispatchQueue.main.async { completion((streamsArray, nil, nil)) }
                            return
                        }
                    } catch {
                        Logger.shared.log("JSON parsing error: \(error.localizedDescription)", type: "Error")
                    }
                    
                    Logger.shared.log("Starting stream from: \(jsonString)", type: "Stream")
                    DispatchQueue.main.async {
                        completion(([jsonString], nil, nil))
                    }
                }
                
                let catchBlock: @convention(block) (JSValue) -> Void = { error in
                    let errorMessage = error.toString() ?? "Unknown JavaScript error"
                    Logger.shared.log("Promise rejected: \(errorMessage)", type: "Error")
                    DispatchQueue.main.async {
                        completion((nil, nil, nil))
                    }
                }
                
                let thenFunction = JSValue(object: thenBlock, in: self.context)
                let catchFunction = JSValue(object: catchBlock, in: self.context)
                
                guard let thenFunction = thenFunction, let catchFunction = catchFunction else {
                    Logger.shared.log("Failed to create JSValue objects for Promise handling", type: "Error")
                    completion((nil, nil, nil))
                    return
                }
                
                promise.invokeMethod("then", withArguments: [thenFunction])
                promise.invokeMethod("catch", withArguments: [catchFunction])
            }
        }
        task.resume()
    }
}
