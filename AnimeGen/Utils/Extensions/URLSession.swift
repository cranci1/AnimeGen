//
//  URLSession.swift
//  AnimeGen
//

import Foundation
import Kingfisher

public struct ProxyConfig: Codable, Equatable {
    public var isEnabled: Bool = false
    public var host: String = ""
    public var port: Int = 8080
    public var isSOCKS: Bool = false
    public var username: String = ""
    public var password: String = ""
    
    public init(
        isEnabled: Bool = false,
        host: String = "",
        port: Int = 8080,
        isSOCKS: Bool = false,
        username: String = "",
        password: String = ""
    ) {
        self.isEnabled = isEnabled
        self.host = host
        self.port = port
        self.isSOCKS = isSOCKS
        self.username = username
        self.password = password
    }
}

public final class AppProxySessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate {
    public static let shared = AppProxySessionDelegate()
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.isProxy() {
            let proxy = AppNetworkManager.currentProxy
            if !proxy.username.isEmpty {
                let credential = URLCredential(user: proxy.username, password: proxy.password, persistence: .forSession)
                completionHandler(.useCredential, credential)
                return
            }
        }
        completionHandler(.performDefaultHandling, nil)
    }
}

public enum AppNetworkManager {
    public static var currentProxy: ProxyConfig = {
        if let data = UserDefaults.standard.data(forKey: "app_proxy_config_v1"),
           let decoded = try? JSONDecoder().decode(ProxyConfig.self, from: data) {
            return decoded
        }
        return ProxyConfig()
    }()
    
    public static func saveProxy(_ config: ProxyConfig) {
        currentProxy = config
        if let encoded = try? JSONEncoder().encode(config) {
            UserDefaults.standard.set(encoded, forKey: "app_proxy_config_v1")
        }
        syncWithKingfisher()
    }
    
    public static func syncWithKingfisher() {
        let config = makeConfiguration(for: currentProxy)
        KingfisherManager.shared.downloader.sessionConfiguration = config
        KingfisherManager.shared.downloader.downloadTimeout = currentProxy.isEnabled ? 20.0 : 10.0
    }
    
    public static func makeConfiguration(for proxy: ProxyConfig) -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        let isProxy = proxy.isEnabled && !proxy.host.isEmpty && proxy.port > 0
        configuration.timeoutIntervalForRequest = isProxy ? 20.0 : 10.0
        configuration.timeoutIntervalForResource = isProxy ? 40.0 : 15.0
        configuration.waitsForConnectivity = false
        configuration.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Safari/604.1",
            "Accept": "application/json, image/*, */*"
        ]
        
        if proxy.isEnabled && !proxy.host.isEmpty && proxy.port > 0 {
            var proxyDict: [AnyHashable: Any] = [:]
            
            if proxy.isSOCKS {
                proxyDict["SOCKSEnable"] = 1
                proxyDict["SOCKSProxy"] = proxy.host
                proxyDict["SOCKSPort"] = proxy.port
                if !proxy.username.isEmpty {
                    proxyDict["SOCKSUser"] = proxy.username
                    proxyDict["SOCKSPassword"] = proxy.password
                }
            } else {
                proxyDict["HTTPEnable"] = 1
                proxyDict["HTTPProxy"] = proxy.host
                proxyDict["HTTPPort"] = proxy.port
                proxyDict["HTTPSEnable"] = 1
                proxyDict["HTTPSProxy"] = proxy.host
                proxyDict["HTTPSPort"] = proxy.port
            }
            configuration.connectionProxyDictionary = proxyDict
            
            if !proxy.username.isEmpty {
                let authString = "\(proxy.username):\(proxy.password)"
                if let authData = authString.data(using: .utf8) {
                    let base64Auth = authData.base64EncodedString()
                    var headers = configuration.httpAdditionalHeaders ?? [:]
                    headers["Proxy-Authorization"] = "Basic \(base64Auth)"
                    configuration.httpAdditionalHeaders = headers
                }
            }
        }
        
        return configuration
    }
    
    public static func makeSession(for proxy: ProxyConfig = currentProxy) -> URLSession {
        let config = makeConfiguration(for: proxy)
        return URLSession(configuration: config, delegate: AppProxySessionDelegate.shared, delegateQueue: nil)
    }
    
    public static func testProxy(config: ProxyConfig) async throws -> (latency: Double, ip: String) {
        let testSession = makeSession(for: config)
        guard let testURL = URL(string: "https://api.ipify.org?format=json") else {
            throw URLError(.badURL)
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        let (data, response) = try await testSession.data(from: testURL)
        let latency = (CFAbsoluteTimeGetCurrent() - startTime) * 1000.0
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NSError(domain: "ProxyTest", code: status, userInfo: [NSLocalizedDescriptionKey: "HTTP Status \(status)"])
        }
        
        struct IPResponse: Decodable {
            let ip: String
        }
        
        let decoded = try JSONDecoder().decode(IPResponse.self, from: data)
        return (latency: latency, ip: decoded.ip)
    }
}

extension URLSession {
    public static var custom: URLSession {
        AppNetworkManager.makeSession()
    }
}

