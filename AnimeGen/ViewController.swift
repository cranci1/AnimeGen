//
//  ViewController.swift
//  AnimeGen
//

import UIKit
import SwiftUI
import Photos
import Kingfisher
import SafariServices

// MARK: - Models & Enums

public enum ImageSource: String, CaseIterable, Identifiable, Codable {
    case nekosBest = "nekosBest"
    case picRe = "picRe"
    case nekoBot = "nekoBot"
    case nekosApi = "nekosApi"
    case nekosLife = "nekosLife"
    case nekosMoe = "nekosMoe"
    case purr = "purr"
    case waifupics = "waifuPics"
    case waifuIm = "waifuIm"
    case nekoBotHentai = "nekoBotHentai"
    case nekoBotNSFWGIF = "nekoBotNSFWGIF"
    case purrNSFW = "purrNSFW"
    case danbooruNSFW = "danbooruNSFW"
    case random = "random"
    
    public var id: String { rawValue }
    
    public var isNSFW: Bool {
        switch self {
        case .nekoBotHentai, .nekoBotNSFWGIF, .purrNSFW, .danbooruNSFW:
            return true
        default:
            return false
        }
    }
    
    public var displayName: String {
        switch self {
        case .nekosBest: return "Nekos Best"
        case .picRe: return "Pic.re HD"
        case .nekoBot: return "NekoBot"
        case .nekosApi: return "Nekos API"
        case .nekosLife: return "Nekos Life"
        case .nekosMoe: return "Nekos Moe"
        case .purr: return "PurrBot"
        case .waifupics: return "Otaku GIFs"
        case .waifuIm: return "Waifu.im"
        case .nekoBotHentai: return "NekoBot 18+"
        case .nekoBotNSFWGIF: return "NekoBot 18+ GIF"
        case .purrNSFW: return "PurrBot 18+ GIF"
        case .danbooruNSFW: return "Danbooru R-18"
        case .random: return "Random Mix"
        }
    }
    
    public var iconName: String {
        switch self {
        case .nekosBest: return "sparkles"
        case .picRe: return "photo.artframe"
        case .nekoBot: return "cat.fill"
        case .nekosApi: return "star.fill"
        case .nekosLife: return "heart.fill"
        case .nekosMoe: return "paintpalette.fill"
        case .purr: return "pawprint.fill"
        case .waifupics: return "play.rectangle.fill"
        case .waifuIm: return "person.crop.circle.fill"
        case .nekoBotHentai: return "flame.fill"
        case .nekoBotNSFWGIF: return "play.square.fill"
        case .purrNSFW: return "flame.circle.fill"
        case .danbooruNSFW: return "heart.slash.fill"
        case .random: return "dice.fill"
        }
    }
    
    public var description: String {
        switch self {
        case .nekosBest: return "High-res anime characters & actions"
        case .picRe: return "High quality Pixiv anime illustrations"
        case .nekoBot: return "Kemonomimi, nekos & anime art"
        case .nekosApi: return "Curated anime illustrations database"
        case .nekosLife: return "Classic reactions & waifus"
        case .nekosMoe: return "Community-curated anime gallery"
        case .purr: return "Cute wallpapers & reaction GIFs"
        case .waifupics: return "High quality animated anime GIFs"
        case .waifuIm: return "Diverse waifu illustrations"
        case .nekoBotHentai: return "Hentai art & illustrations (18+)"
        case .nekoBotNSFWGIF: return "Animated adult anime GIFs (18+)"
        case .purrNSFW: return "Adult 60 FPS animated reaction GIFs (18+)"
        case .danbooruNSFW: return "Curated R-18 artwork database (18+)"
        case .random: return "Picks a random enabled source"
        }
    }
    
    public var tag: String {
        switch self {
        case .waifupics: return "GIF"
        case .picRe: return "HD"
        case .nekosBest: return "Top"
        case .random: return "Mix"
        case .nekoBotHentai: return "18+ 🔥"
        case .nekoBotNSFWGIF: return "GIF 18+ 🔥"
        case .purrNSFW: return "GIF 18+ 🔥"
        case .danbooruNSFW: return "R-18 🔥"
        default: return "SFW"
        }
    }
}

public enum OrientationMode: String, CaseIterable, Identifiable, Codable {
    case vertical = "vertical"
    case any = "any"
    case horizontal = "horizontal"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .vertical: return "Vertical (9:16)"
        case .any: return "Any Aspect (Mix)"
        case .horizontal: return "Horizontal (16:9)"
        }
    }
    
    public var shortTitle: String {
        switch self {
        case .vertical: return "9:16"
        case .any: return "Mix"
        case .horizontal: return "16:9"
        }
    }
    
    public var iconName: String {
        switch self {
        case .vertical: return "iphone"
        case .any: return "rectangle.dashed"
        case .horizontal: return "ipad.landscape"
        }
    }
}

public enum ImageScaleMode: String, CaseIterable, Identifiable, Codable {
    case fill = "fill"
    case fit = "fit"
    
    public var id: String { rawValue }
    
    public var title: String {
        switch self {
        case .fill: return "Fill Screen"
        case .fit: return "Fit Screen"
        }
    }
    
    public var iconName: String {
        switch self {
        case .fill: return "arrow.up.left.and.arrow.down.right"
        case .fit: return "arrow.down.right.and.arrow.up.left"
        }
    }
}

public struct CustomSourceItem: Identifiable, Codable, Equatable {
    public var id = UUID()
    public var name: String
    public var endpointURL: String
    public var jsonKeyPath: String
    public var isEnabled: Bool = true
    
    public init(name: String, endpointURL: String, jsonKeyPath: String, isEnabled: Bool = true) {
        self.name = name
        self.endpointURL = endpointURL
        self.jsonKeyPath = jsonKeyPath
        self.isEnabled = isEnabled
    }
}

public struct AnimeArtItem: Identifiable, Equatable, Codable {
    public let id: UUID
    public let imageURL: URL
    public let source: ImageSource
    public let category: String
    public let artistName: String?
    public let artistURL: URL?
    public let sourceURL: URL?
    public let tags: [String]
    public let isGIF: Bool
    public let timestamp: Date
    
    public init(
        imageURL: URL,
        source: ImageSource,
        category: String = "Anime",
        artistName: String? = nil,
        artistURL: URL? = nil,
        sourceURL: URL? = nil,
        tags: [String] = [],
        isGIF: Bool = false
    ) {
        self.id = UUID()
        self.imageURL = imageURL
        self.source = source
        self.category = category
        self.artistName = artistName
        self.artistURL = artistURL
        self.sourceURL = sourceURL
        self.tags = tags
        self.isGIF = isGIF
        self.timestamp = Date()
    }
    
    public static func == (lhs: AnimeArtItem, rhs: AnimeArtItem) -> Bool {
        lhs.imageURL == rhs.imageURL
    }
}

// MARK: - Debug Logger

public struct DebugLogEntry: Identifiable {
    public let id = UUID()
    public let timestamp = Date()
    public let tag: String
    public let message: String
    public let isError: Bool
    public let details: String?
    
    public var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: timestamp)
    }
}

@MainActor
public class DebugLogger: ObservableObject {
    public static let shared = DebugLogger()
    
    @Published public var logs: [DebugLogEntry] = []
    
    public func log(tag: String, message: String, isError: Bool = false, details: String? = nil) {
        let entry = DebugLogEntry(tag: tag, message: message, isError: isError, details: details)
        logs.append(entry)
        if logs.count > 250 {
            logs.removeFirst(50)
        }
    }
    
    public func clear() {
        logs.removeAll()
    }
    
    public var allLogsFormatted: String {
        let device = UIDevice.current
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "3.1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "21"
        var text = "=== AnimeGen Debug Log ===\n"
        text += "App Version: \(version) (Build \(build))\n"
        text += "iOS: \(device.systemName) \(device.systemVersion)\n"
        text += "Device: \(device.model)\n"
        text += "Total Logs: \(logs.count)\n"
        text += "===========================\n\n"
        
        let logsText = logs.map { entry in
            var logLine = "[\(entry.timeString)] [\(entry.tag)] \(entry.isError ? "❌ " : "ℹ️ ")\(entry.message)"
            if let details = entry.details, !details.isEmpty {
                logLine += "\n  Details: \(details)"
            }
            return logLine
        }.joined(separator: "\n\n")
        
        return text + logsText
    }
}

// MARK: - ViewModel

@MainActor
public class AnimeGenViewModel: ObservableObject {
    @Published public var currentItem: AnimeArtItem?
    @Published public var history: [AnimeArtItem] = []
    @Published public var favorites: [AnimeArtItem] = []
    @Published public var historyIndex: Int = -1
    @Published public var selectedSource: ImageSource = .nekosBest
    @Published public var orientationMode: OrientationMode = .vertical
    @Published public var scaleMode: ImageScaleMode = .fill
    @Published public var disabledSources: Set<String> = []
    @Published public var customSources: [CustomSourceItem] = []
    
    @Published public var proxyConfig: ProxyConfig = AppNetworkManager.currentProxy
    @Published public var isNSFWEnabled: Bool = UserDefaults.standard.bool(forKey: "is_nsfw_enabled_v1")
    @Published public var showAgeVerificationAlert: Bool = false
    
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var failedSource: ImageSource? = nil
    @Published public var toastMessage: String? = nil
    
    @Published public var showSourceSheet: Bool = false
    @Published public var showAppMenuSheet: Bool = false
    @Published public var showHistorySheet: Bool = false
    @Published public var showFavoritesSheet: Bool = false
    @Published public var showSourceManagerSheet: Bool = false
    @Published public var showProxySheet: Bool = false
    @Published public var showDebugSheet: Bool = false
    
    private let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    public init() {
        // Load saved source
        if let savedSource = UserDefaults.standard.string(forKey: "selectedSource"),
           let source = ImageSource(rawValue: savedSource) {
            if source.isNSFW && !UserDefaults.standard.bool(forKey: "is_nsfw_enabled_v1") {
                self.selectedSource = .nekosBest
            } else {
                self.selectedSource = source
            }
        }
        
        // Load orientation preference
        if let savedMode = UserDefaults.standard.string(forKey: "orientationMode"),
           let mode = OrientationMode(rawValue: savedMode) {
            self.orientationMode = mode
        }
        
        // Load scale mode (Fill vs Fit)
        if let savedScale = UserDefaults.standard.string(forKey: "imageScaleMode"),
           let scale = ImageScaleMode(rawValue: savedScale) {
            self.scaleMode = scale
        }
        
        // Load disabled sources
        if let disabled = UserDefaults.standard.stringArray(forKey: "disabledSources") {
            self.disabledSources = Set(disabled)
        }
        
        // Load saved custom sources
        if let customData = UserDefaults.standard.data(forKey: "custom_sources_v1"),
           let decoded = try? JSONDecoder().decode([CustomSourceItem].self, from: customData) {
            self.customSources = decoded
        }
        
        // Load persistent favorites
        loadFavorites()
        
        // Configure Kingfisher
        KingfisherManager.shared.downloader.downloadTimeout = 6.0
        
        DebugLogger.shared.log(tag: "App", message: "AnimeGen initialized with source: \(selectedSource.displayName)")
        loadNewImage()
    }
    
    public func requestToggleNSFW() {
        if isNSFWEnabled {
            isNSFWEnabled = false
            UserDefaults.standard.set(false, forKey: "is_nsfw_enabled_v1")
            showToast("18+ Content Disabled")
            if selectedSource.isNSFW {
                setSource(.nekosBest)
            }
        } else {
            showAgeVerificationAlert = true
        }
    }
    
    public func confirmAgeVerification() {
        isNSFWEnabled = true
        UserDefaults.standard.set(true, forKey: "is_nsfw_enabled_v1")
        
        // Auto-enable all NSFW sources so they don't remain disabled
        for nsfwSrc in ImageSource.allCases.filter({ $0.isNSFW }) {
            disabledSources.remove(nsfwSrc.rawValue)
        }
        UserDefaults.standard.set(Array(disabledSources), forKey: "disabledSources")
        
        showToast("18+ Content Enabled 🔥")
        DebugLogger.shared.log(tag: "NSFW", message: "NSFW adult content enabled after 18+ age verification")
    }
    
    public func setSource(_ source: ImageSource) {
        if source == .waifuIm {
            showToast("Waifu.im is under maintenance (Cloudflare) ⚠️")
            return
        }
        selectedSource = source
        UserDefaults.standard.set(source.rawValue, forKey: "selectedSource")
        DebugLogger.shared.log(tag: "Source", message: "Selected source: \(source.displayName)")
        showToast("Switched to \(source.displayName)")
        loadNewImage()
    }
    
    public func setOrientationMode(_ mode: OrientationMode) {
        orientationMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: "orientationMode")
        showToast("Mode: \(mode.title)")
        loadNewImage()
    }
    
    public func toggleScaleMode() {
        scaleMode = (scaleMode == .fill) ? .fit : .fill
        UserDefaults.standard.set(scaleMode.rawValue, forKey: "imageScaleMode")
        impactFeedback.impactOccurred()
        showToast(scaleMode == .fill ? "Scale: Fill Screen" : "Scale: Fit Screen")
    }
    
    public func toggleSourceEnabled(_ source: ImageSource) {
        if source == .waifuIm { return }
        if disabledSources.contains(source.rawValue) {
            disabledSources.remove(source.rawValue)
        } else {
            disabledSources.insert(source.rawValue)
        }
        UserDefaults.standard.set(Array(disabledSources), forKey: "disabledSources")
    }
    
    public func isSourceEnabled(_ source: ImageSource) -> Bool {
        if source == .waifuIm {
            return false
        }
        if source.isNSFW && !isNSFWEnabled {
            return false
        }
        return !disabledSources.contains(source.rawValue)
    }
    
    public func saveCustomSources() {
        if let encoded = try? JSONEncoder().encode(customSources) {
            UserDefaults.standard.set(encoded, forKey: "custom_sources_v1")
        }
    }
    
    public func saveProxySettings() {
        AppNetworkManager.saveProxy(proxyConfig)
        showToast("Proxy settings saved! 🌐")
        DebugLogger.shared.log(tag: "Proxy", message: "Proxy updated: \(proxyConfig.isEnabled ? "Enabled (\(proxyConfig.host):\(proxyConfig.port))" : "Disabled")")
    }
    
    public func loadNewImage(targetSource: ImageSource? = nil) {
        let sourceToUse = targetSource ?? selectedSource
        let actualSource: ImageSource
        if sourceToUse == .random {
            let selectableSources = ImageSource.allCases.filter { 
                $0 != .random && 
                (!$0.isNSFW || isNSFWEnabled) && 
                !disabledSources.contains($0.rawValue) 
            }
            actualSource = selectableSources.randomElement() ?? .nekosBest
        } else {
            actualSource = sourceToUse
        }
        
        isLoading = true
        errorMessage = nil
        failedSource = nil
        impactFeedback.prepare()
        
        let startTime = CFAbsoluteTimeGetCurrent()
        DebugLogger.shared.log(tag: "Fetch", message: "Requesting art from \(actualSource.displayName) [\(orientationMode.rawValue)]...")
        
        Task {
            do {
                let item: AnimeArtItem
                switch actualSource {
                case .nekosBest:
                    item = try await NekosBestAPI.fetch(orientation: self.orientationMode)
                case .picRe:
                    item = try await PicReAPI.fetch(orientation: self.orientationMode)
                case .nekoBot:
                    item = try await NekoBotAPI.fetch(orientation: self.orientationMode)
                case .nekosApi:
                    item = try await NekosApiAPI.fetch()
                case .nekosLife:
                    item = try await NekosLifeAPI.fetch(orientation: self.orientationMode)
                case .nekosMoe:
                    item = try await NekosMoeAPI.fetch()
                case .purr:
                    item = try await PurrAPI.fetch(orientation: self.orientationMode)
                case .waifupics:
                    item = try await WaifuPicsAPI.fetch(orientation: self.orientationMode)
                case .waifuIm:
                    item = try await WaifuImAPI.fetch()
                case .nekoBotHentai:
                    item = try await NekoBotNSFWAPI.fetch(isGIFOnly: false)
                case .nekoBotNSFWGIF:
                    item = try await NekoBotNSFWAPI.fetch(isGIFOnly: true)
                case .purrNSFW:
                    item = try await PurrBotNSFWAPI.fetch()
                case .danbooruNSFW:
                    item = try await DanbooruAPI.fetch(isNSFW: true)
                case .random:
                    item = try await NekosBestAPI.fetch(orientation: self.orientationMode)
                }
                
                let duration = String(format: "%.2f", (CFAbsoluteTimeGetCurrent() - startTime) * 1000)
                DebugLogger.shared.log(tag: "Fetch", message: "Received \(item.category) from \(actualSource.displayName) in \(duration)ms", isError: false, details: item.imageURL.absoluteString)
                
                self.currentItem = item
                self.history.append(item)
                self.historyIndex = self.history.count - 1
                self.isLoading = false
            } catch {
                let duration = String(format: "%.2f", (CFAbsoluteTimeGetCurrent() - startTime) * 1000)
                let errDesc = error.localizedDescription
                DebugLogger.shared.log(tag: "Fetch", message: "Failed \(actualSource.displayName) after \(duration)ms: \(errDesc)", isError: true, details: "\(error)")
                
                self.failedSource = actualSource
                self.errorMessage = "Server \(actualSource.displayName) is temporarily unavailable or rejected the request."
                self.isLoading = false
            }
        }
    }
    
    public func handleImageDownloadError(for item: AnimeArtItem, error: Error) {
        DebugLogger.shared.log(tag: "ImageCDN", message: "Failed to download image: \(error.localizedDescription)", isError: true, details: item.imageURL.absoluteString)
        self.failedSource = item.source
        self.errorMessage = "Failed to load image from \(item.source.displayName). CDN is temporarily unavailable."
    }
    
    public func goPrevious() {
        guard historyIndex > 0 else { return }
        historyIndex -= 1
        currentItem = history[historyIndex]
        errorMessage = nil
        failedSource = nil
        impactFeedback.impactOccurred()
    }
    
    public func goNext() {
        if historyIndex < history.count - 1 {
            historyIndex += 1
            currentItem = history[historyIndex]
            errorMessage = nil
            failedSource = nil
            impactFeedback.impactOccurred()
        } else {
            loadNewImage()
        }
    }
    
    // MARK: - Favorites Management (Persistent)
    
    public var isFavorite: Bool {
        guard let current = currentItem else { return false }
        return favorites.contains { $0.imageURL == current.imageURL }
    }
    
    public func toggleFavorite() {
        guard let current = currentItem else { return }
        if let idx = favorites.firstIndex(where: { $0.imageURL == current.imageURL }) {
            favorites.remove(at: idx)
            saveFavorites()
            showToast("Removed from favorites")
        } else {
            favorites.append(current)
            saveFavorites()
            notificationFeedback.notificationOccurred(.success)
            showToast("Added to favorites! ❤️")
        }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "saved_favorites_v1")
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "saved_favorites_v1"),
           let decoded = try? JSONDecoder().decode([AnimeArtItem].self, from: data) {
            self.favorites = decoded
        }
    }
    
    public func saveToPhotos() {
        guard let current = currentItem else { return }
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard let self = self else { return }
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self.showToast("Photos access required in Settings")
                }
                return
            }
            
            let url = current.imageURL
            let isGIF = current.isGIF || url.pathExtension.lowercased() == "gif"
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.showToast("Failed to download image")
                    }
                    return
                }
                
                if isGIF {
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("temp_\(UUID().uuidString).gif")
                    do {
                        try data.write(to: tempURL)
                        PHPhotoLibrary.shared().performChanges({
                            let req = PHAssetCreationRequest.forAsset()
                            req.addResource(with: .photo, fileURL: tempURL, options: nil)
                        }) { success, _ in
                            try? FileManager.default.removeItem(at: tempURL)
                            DispatchQueue.main.async {
                                if success {
                                    self.notificationFeedback.notificationOccurred(.success)
                                    self.showToast("GIF saved to Photos! 🎉")
                                } else {
                                    self.showToast("Failed to save GIF")
                                }
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.showToast("Failed to write GIF data")
                        }
                    }
                } else if let image = UIImage(data: data) {
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAsset(from: image)
                    }) { success, _ in
                        DispatchQueue.main.async {
                            if success {
                                self.notificationFeedback.notificationOccurred(.success)
                                self.showToast("Saved to Photos! 🎉")
                            } else {
                                self.showToast("Failed to save image")
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    public func showToast(_ message: String) {
        toastMessage = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            if self.toastMessage == message {
                self.toastMessage = nil
            }
        }
    }
    
    public func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            DispatchQueue.main.async {
                self.showToast("Image cache cleared! 🧹")
                DebugLogger.shared.log(tag: "Cache", message: "Disk and memory image cache cleared")
            }
        }
    }
}

// MARK: - Animated GIF View (60 FPS Hardware-Accelerated)

struct AnimatedGIFView: UIViewRepresentable {
    let url: URL
    let contentMode: UIView.ContentMode
    
    func makeUIView(context: Context) -> AnimatedImageView {
        let view = AnimatedImageView()
        view.contentMode = contentMode
        view.clipsToBounds = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.kf.indicatorType = .activity
        return view
    }
    
    func updateUIView(_ uiView: AnimatedImageView, context: Context) {
        uiView.contentMode = contentMode
        uiView.kf.setImage(
            with: url,
            options: [
                .transition(.fade(0.15)),
                .cacheOriginalImage
            ]
        )
    }
}

// MARK: - Modern SwiftUI UI

struct ModernContentView: View {
    @StateObject private var viewModel = AnimeGenViewModel()
    @StateObject private var debugLogger = DebugLogger.shared
    @State private var dragOffset: CGFloat = 0
    @State private var zoomScale: CGFloat = 1.0
    @State private var showHeartAnimation: Bool = false
    
    var body: some View {
        VStack(spacing: 6) {
            // Top Header Bar
            topHeaderBar
                .padding(.horizontal, 14)
                .padding(.top, 4)
            
            // Center Interactive HD Canvas (Fills Screen Beautifully)
            mainImageCanvas
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
            
            // Bottom Compact Floating Toolbar Capsule (Lowered for Ergonomics)
            bottomToolbarCapsule
                .padding(.horizontal, 14)
                .padding(.bottom, 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ambientBackground
                .ignoresSafeArea()
        )
        .overlay(
            // Toast HUD
            VStack {
                if let toast = viewModel.toastMessage {
                    toastView(text: toast)
                        .padding(.top, 8)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
                Spacer()
            }
            .animation(.spring(), value: viewModel.toastMessage)
        )
        .overlay(
            // Double-Tap Heart Overlay Animation
            Group {
                if showHeartAnimation {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 76))
                        .foregroundColor(.red.opacity(0.92))
                        .scaleEffect(showHeartAnimation ? 1.25 : 0.4)
                        .opacity(showHeartAnimation ? 1 : 0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: showHeartAnimation)
                        .shadow(color: .black.opacity(0.4), radius: 15, x: 0, y: 8)
                }
            }
        )
        .sheet(isPresented: $viewModel.showSourceSheet) {
            SourcePickerSheet(viewModel: viewModel)
        }
        .sheet(isPresented: $viewModel.showAppMenuSheet) {
            AppMenuSheet(viewModel: viewModel)
        }
    }
    
    // MARK: - Vibrant Ambient Background
    private var ambientBackground: some View {
        ZStack {
            Color(UIColor.systemBackground)
            
            if let current = viewModel.currentItem {
                KFImage(current.imageURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 35)
                    .opacity(0.60)
            }
            
            // Rich radial gradient bloom
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.pink.opacity(0.18),
                    Color.purple.opacity(0.12),
                    Color.black.opacity(0.35)
                ]),
                center: .center,
                startRadius: 40,
                endRadius: 400
            )
            
            LinearGradient(
                colors: [
                    Color(UIColor.systemBackground).opacity(0.3),
                    Color.clear,
                    Color(UIColor.systemBackground).opacity(0.6)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    // MARK: - Top Header Bar
    private var topHeaderBar: some View {
        HStack(spacing: 8) {
            // Source Selector Button (Enhanced Light/Dark Contrast)
            Button(action: {
                viewModel.showSourceSheet = true
            }) {
                HStack(spacing: 6) {
                    Image(systemName: viewModel.selectedSource.iconName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(viewModel.selectedSource.isNSFW ? .red : .pink)
                    
                    Text(viewModel.selectedSource.displayName)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundColor(viewModel.selectedSource.isNSFW ? .red : Color(UIColor.label))
                        .lineLimit(1)
                    
                    if viewModel.selectedSource.isNSFW {
                        Text("18+")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.red.opacity(0.2), in: Capsule())
                            .foregroundColor(.red)
                    }
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 11)
                .padding(.vertical, 7)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(
                    Capsule().stroke(viewModel.selectedSource.isNSFW ? Color.red.opacity(0.5) : Color(UIColor.separator).opacity(0.35), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            }
            
            Spacer(minLength: 4)
            
            // Orientation Mode Switcher Pill
            Button(action: {
                switch viewModel.orientationMode {
                case .vertical: viewModel.setOrientationMode(.any)
                case .any: viewModel.setOrientationMode(.horizontal)
                case .horizontal: viewModel.setOrientationMode(.vertical)
                }
            }) {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.orientationMode.iconName)
                        .font(.system(size: 11, weight: .bold))
                    Text(viewModel.orientationMode.shortTitle)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                }
                .padding(.horizontal, 9)
                .padding(.vertical, 7)
                .background(.ultraThinMaterial, in: Capsule())
                .overlay(
                    Capsule().stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
                )
                .foregroundColor(Color(UIColor.label))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            }
            
            // Action Menu Button
            Button(action: {
                viewModel.showAppMenuSheet = true
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                    .padding(8)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(
                        Circle().stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    // MARK: - Main Image Canvas
    private var mainImageCanvas: some View {
        GeometryReader { geo in
            ZStack {
                // Glass Card Container (Zero Square Corners)
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.ultraThinMaterial.opacity(0.88))
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color(UIColor.separator).opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.18), radius: 18, x: 0, y: 8)
                
                if let _ = viewModel.errorMessage, let failedSrc = viewModel.failedSource {
                    // Apple Liquid Glass Error State
                    liquidGlassErrorView(source: failedSrc)
                } else if let item = viewModel.currentItem {
                    ZStack {
                        if item.isGIF || item.imageURL.absoluteString.lowercased().hasSuffix(".gif") {
                            AnimatedGIFView(
                                url: item.imageURL,
                                contentMode: viewModel.scaleMode == .fill ? .scaleAspectFill : .scaleAspectFit
                            )
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()
                        } else if viewModel.scaleMode == .fill {
                            KFImage(item.imageURL)
                                .placeholder { loadingSpinner }
                                .fade(duration: 0.2)
                                .onFailure { error in
                                    viewModel.handleImageDownloadError(for: item, error: error)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .clipped()
                        } else {
                            KFImage(item.imageURL)
                                .placeholder { loadingSpinner }
                                .fade(duration: 0.2)
                                .onFailure { error in
                                    viewModel.handleImageDownloadError(for: item, error: error)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geo.size.width, height: geo.size.height)
                                .padding(4)
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .scaleEffect(zoomScale)
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation.width
                            }
                            .onEnded { value in
                                if value.translation.width < -50 {
                                    viewModel.goNext()
                                } else if value.translation.width > 50 {
                                    viewModel.goPrevious()
                                }
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    dragOffset = 0
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { scale in
                                zoomScale = max(1.0, min(scale, 4.0))
                            }
                            .onEnded { _ in
                                withAnimation(.spring()) {
                                    zoomScale = 1.0
                                }
                            }
                    )
                    .onTapGesture(count: 2) {
                        viewModel.toggleFavorite()
                        showHeartAnimation = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            showHeartAnimation = false
                        }
                    }
                    
                    // Metadata Badges & Fill/Fit Mode Switcher inside the Card
                    VStack {
                        HStack(spacing: 6) {
                            Text(item.category)
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                                .padding(.horizontal, 9)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                                .foregroundColor(Color(UIColor.label))
                                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                            
                            Spacer()
                            
                            // Fill vs Fit Mode Quick Switcher Button
                            Button(action: {
                                viewModel.toggleScaleMode()
                            }) {
                                HStack(spacing: 3) {
                                    Image(systemName: viewModel.scaleMode.iconName)
                                        .font(.system(size: 10, weight: .bold))
                                    Text(viewModel.scaleMode.title)
                                        .font(.system(size: 9, weight: .bold, design: .rounded))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial, in: Capsule())
                                .foregroundColor(Color(UIColor.label))
                                .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                            }
                            
                            if item.isGIF {
                                Text("GIF")
                                    .font(.system(size: 9, weight: .black, design: .rounded))
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 4)
                                    .background(Color.pink.opacity(0.9), in: Capsule())
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                            }
                        }
                        .padding(10)
                        
                        Spacer()
                        
                        if let artist = item.artistName, !artist.isEmpty {
                            HStack {
                                Button(action: {
                                    if let url = item.artistURL ?? item.sourceURL {
                                        openSafari(url: url)
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: "paintpalette.fill")
                                        Text(artist)
                                        if item.artistURL != nil || item.sourceURL != nil {
                                            Image(systemName: "arrow.up.right")
                                                .font(.system(size: 8))
                                        }
                                    }
                                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 4)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .foregroundColor(.secondary)
                                    .shadow(color: .black.opacity(0.12), radius: 4, x: 0, y: 2)
                                }
                                Spacer()
                            }
                            .padding(10)
                        }
                    }
                } else if viewModel.isLoading {
                    VStack(spacing: 10) {
                        ProgressView()
                            .scaleEffect(1.3)
                        Text("Summoning anime art...")
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
    
    private var loadingSpinner: some View {
        VStack(spacing: 10) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading HD Art...")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - Liquid Glass Error Card
    private func liquidGlassErrorView(source: ImageSource) -> some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.18))
                    .frame(width: 64, height: 64)
                
                Image(systemName: "wifi.exclamationmark")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.orange)
            }
            
            VStack(spacing: 6) {
                Text("Source Not Responding")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                
                Text("Server \(source.displayName) is temporarily unreachable or timed out.")
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 10) {
                Button(action: {
                    viewModel.showSourceSheet = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "square.grid.2x2.fill")
                        Text("Select Another Source")
                    }
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: 240)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: [Color.pink, Color.purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        in: Capsule()
                    )
                    .shadow(color: Color.pink.opacity(0.3), radius: 6, x: 0, y: 3)
                }
                
                Button(action: {
                    viewModel.loadNewImage()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(Color(UIColor.label))
                    .frame(maxWidth: 240)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(
                        Capsule().stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
                    )
                }
                
                Button(action: {
                    viewModel.showDebugSheet = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "ladybug")
                        Text("View Debug Logs")
                    }
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.secondary)
                }
                .padding(.top, 4)
            }
        }
        .padding(24)
    }
    
    // MARK: - Bottom Floating Toolbar Capsule
    private var bottomToolbarCapsule: some View {
        HStack(spacing: 12) {
            // Previous Button
            Button(action: {
                viewModel.goPrevious()
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(viewModel.historyIndex > 0 ? Color(UIColor.label) : .secondary.opacity(0.4))
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .disabled(viewModel.historyIndex <= 0)
            
            // Favorite Button
            Button(action: {
                viewModel.toggleFavorite()
            }) {
                Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(viewModel.isFavorite ? .red : Color(UIColor.label))
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            // Generate / Next Hero FAB Button
            Button(action: {
                viewModel.loadNewImage()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.pink, Color.purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                        .shadow(color: Color.pink.opacity(0.45), radius: 8, x: 0, y: 4)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.9)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .disabled(viewModel.isLoading)
            
            // Save to Photos Button
            Button(action: {
                viewModel.saveToPhotos()
            }) {
                Image(systemName: "arrow.down.to.line")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial, in: Circle())
            }
            
            // Share Sheet Button
            Button(action: {
                shareCurrentArt()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(UIColor.label))
                    .frame(width: 38, height: 38)
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 5)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule()
                .stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.14), radius: 12, x: 0, y: 6)
    }
    
    // MARK: - Toast HUD View
    private func toastView(text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.pink)
            Text(text)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(Color(UIColor.label))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(
            Capsule().stroke(Color(UIColor.separator).opacity(0.35), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
    
    private func openSafari(url: URL) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? windowScene.windows.first?.rootViewController {
            let safariVC = SFSafariViewController(url: url)
            rootVC.present(safariVC, animated: true)
        }
    }
    
    private func shareCurrentArt() {
        guard let current = viewModel.currentItem else { return }
        let activityVC = UIActivityViewController(activityItems: [current.imageURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? windowScene.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = rootVC.view
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Consolidated App Menu Sheet

struct AppMenuSheet: View {
    @ObservedObject var viewModel: AnimeGenViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Collection")) {
                    NavigationLink(destination: GalleryView(
                        title: "Favorites",
                        items: viewModel.favorites,
                        onSelect: { item in
                            viewModel.currentItem = item
                            viewModel.errorMessage = nil
                            viewModel.failedSource = nil
                            dismiss()
                        }
                    )) {
                        Label {
                            HStack {
                                Text("Favorites")
                                Spacer()
                                Text("\(viewModel.favorites.count)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                        }
                    }
                    
                    NavigationLink(destination: GalleryView(
                        title: "Session History",
                        items: viewModel.history,
                        onSelect: { item in
                            viewModel.currentItem = item
                            viewModel.errorMessage = nil
                            viewModel.failedSource = nil
                            dismiss()
                        }
                    )) {
                        Label {
                            HStack {
                                Text("Session History")
                                Spacer()
                                Text("\(viewModel.history.count)")
                                    .font(.subheadline.bold())
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "clock.arrow.circlepath").foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Display & Aspect Ratio")) {
                    Picker("Art Orientation", selection: $viewModel.orientationMode) {
                        ForEach(OrientationMode.allCases) { mode in
                            Label(mode.title, systemImage: mode.iconName).tag(mode)
                        }
                    }
                    .pickerStyle(.inline)
                    .onChange(of: viewModel.orientationMode) { newMode in
                        viewModel.setOrientationMode(newMode)
                    }
                    
                    Picker("Image Scaling", selection: $viewModel.scaleMode) {
                        ForEach(ImageScaleMode.allCases) { scale in
                            Label(scale.title, systemImage: scale.iconName).tag(scale)
                        }
                    }
                    .pickerStyle(.inline)
                    .onChange(of: viewModel.scaleMode) { newScale in
                        UserDefaults.standard.set(newScale.rawValue, forKey: "imageScaleMode")
                    }
                }
                
                Section(header: Text("Sources & Network")) {
                    NavigationLink(destination: SourceManagerView(viewModel: viewModel)) {
                        Label("Source Management & Custom APIs", systemImage: "slider.horizontal.3")
                    }
                    
                    NavigationLink(destination: ProxySettingsView(viewModel: viewModel)) {
                        Label("Proxy Settings (HTTP / SOCKS5)", systemImage: "network")
                    }
                }
                
                Section(header: Text("Adult Content (NSFW)").foregroundColor(.red)) {
                    Toggle(isOn: Binding(
                        get: { viewModel.isNSFWEnabled },
                        set: { _ in viewModel.requestToggleNSFW() }
                    )) {
                        Label {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Enable 18+ Content (NSFW)")
                                    .fontWeight(.semibold)
                                    .foregroundColor(viewModel.isNSFWEnabled ? .red : Color(UIColor.label))
                                Text(viewModel.isNSFWEnabled ? "18+ Sources Unlocked 🔥" : "Unlocks adult content sources (18+)")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        } icon: {
                            Image(systemName: "flame.fill")
                                .foregroundColor(viewModel.isNSFWEnabled ? .red : .gray)
                        }
                    }
                }
                
                Section(header: Text("Diagnostics & Tools")) {
                    NavigationLink(destination: DebugConsoleView(viewModel: viewModel, logger: DebugLogger.shared)) {
                        Label("Debug Console & Ping (v3.1)", systemImage: "ladybug.fill")
                    }
                    
                    Button(action: {
                        viewModel.clearCache()
                    }) {
                        Label("Clear Image Cache", systemImage: "trash")
                            .foregroundColor(.orange)
                    }
                }
                
                Section(header: Text("About & Project")) {
                    NavigationLink(destination: CreditsView()) {
                        Label("Authors & Credits", systemImage: "person.2.fill")
                    }
                }
            }
            .navigationTitle("AnimeGen Menu")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Age Verification (18+)", isPresented: $viewModel.showAgeVerificationAlert) {
                Button("I am 18 or older", role: .none) {
                    viewModel.confirmAgeVerification()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you at least 18 years old? Enabling this mode unlocks adult (NSFW) artwork and sources.")
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Authors & Credits View

struct CreditsView: View {
    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "3.1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "21"
        return "v\(version) (Build \(build))"
    }
    
    var body: some View {
        List {
            // App Branding Header
            Section {
                VStack(spacing: 10) {
                    Image("AppLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
                        .padding(.top, 4)
                    
                    Text("AnimeGen")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                    
                    Text(appVersion)
                        .font(.system(size: 12, weight: .semibold, design: .monospaced))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(UIColor.secondarySystemBackground), in: Capsule())
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
            
            // Authors Section
            Section(header: Text("Authors & Maintainers")) {
                Link(destination: URL(string: "https://github.com/cranci1")!) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.pink)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("cranci")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.label))
                            Text("Original creator & maintainer (v1.0 – v3.0)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                
                Link(destination: URL(string: "https://github.com/l1ratch")!) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.badge.shield.checkmark.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.purple)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("l1ratch")
                                .font(.headline)
                                .foregroundColor(Color(UIColor.label))
                            Text("v3.1 modernization (SwiftUI, Custom APIs, Proxy & NSFW)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // GitHub Repositories Section
            Section(header: Text("Source Code & Repositories")) {
                Link(destination: URL(string: "https://github.com/cranci1/AnimeGen")!) {
                    HStack(spacing: 12) {
                        Image(systemName: "curlybraces.square.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Original Repository")
                                .font(.subheadline.bold())
                                .foregroundColor(Color(UIColor.label))
                            Text("github.com/cranci1/AnimeGen")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                
                Link(destination: URL(string: "https://github.com/l1ratch/AnimeGen")!) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.triangle.branch")
                            .font(.system(size: 20))
                            .foregroundColor(.orange)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Fork Repository (v3.1 Modernized)")
                                .font(.subheadline.bold())
                                .foregroundColor(Color(UIColor.label))
                            Text("github.com/l1ratch/AnimeGen")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            // License & Credits Section
            Section(header: Text("License & Third-Party")) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("GNU General Public License v3.0 (GPLv3)")
                        .font(.subheadline.bold())
                    Text("AnimeGen is free and open-source software. You are free to modify, redistribute, and contribute under the terms of the GPLv3 license.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 2)
                
                Link(destination: URL(string: "https://github.com/onevcat/Kingfisher")!) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Kingfisher")
                                .font(.subheadline.bold())
                                .foregroundColor(Color(UIColor.label))
                            Text("Image caching & animated GIF rendering (MIT)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Authors & Credits")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Source Manager View with Step-by-Step Instructions

struct SourceManagerView: View {
    @ObservedObject var viewModel: AnimeGenViewModel
    
    @State private var showAddSheet = false
    @State private var newName = ""
    @State private var newURL = ""
    @State private var newKeyPath = "url"
    
    var body: some View {
        List {
            Section(header: Text("Custom API Guide")) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("💡 How to connect a custom source:")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.pink)
                    
                    Text("1. Enter the source name (e.g. Safebooru or Danbooru).\n2. Provide the JSON endpoint URL that returns an image.\n3. Specify the JSON key path containing the image URL (e.g. `url`, `file_url`, `message`, or `link`).")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Divider().padding(.vertical, 2)
                    
                    Text("Popular Endpoint Examples:")
                        .font(.system(size: 11, weight: .bold))
                    
                    Text("• Safebooru: `https://safebooru.org/index.php?page=dapi&s=post&q=index&json=1&tags=rating:safe+score:>50&limit=1` (key: `file_url`)\n• Nekos API: `https://api.nekosapi.com/v4/images/random?rating=safe` (key: `url`)")
                        .font(.system(size: 10, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
            
            let sfwSources = ImageSource.allCases.filter { $0 != .random && !$0.isNSFW && $0 != .waifuIm }
            Section(header: Text("Built-in Sources (SFW)")) {
                ForEach(sfwSources) { source in
                    HStack {
                        Image(systemName: source.iconName)
                            .foregroundColor(.pink)
                            .frame(width: 24)
                        
                        VStack(alignment: .leading) {
                            Text(source.displayName).font(.headline)
                            Text(source.description).font(.caption).foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Toggle("", isOn: Binding(
                            get: { viewModel.isSourceEnabled(source) },
                            set: { _ in viewModel.toggleSourceEnabled(source) }
                        ))
                        .labelsHidden()
                    }
                }
                
                // Waifu.im on maintenance
                HStack {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .foregroundColor(.secondary)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Waifu.im").font(.headline).foregroundColor(.secondary)
                            Text("Maintenance ⚠️").font(.caption2.bold()).foregroundColor(.orange)
                        }
                        Text("Temporarily disabled for maintenance (Cloudflare)").font(.caption).foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: .constant(false))
                        .labelsHidden()
                        .disabled(true)
                }
                .opacity(0.6)
            }
            
            if viewModel.isNSFWEnabled {
                let nsfwSources = ImageSource.allCases.filter { $0 != .random && $0.isNSFW }
                Section(header: HStack {
                    Image(systemName: "flame.fill").foregroundColor(.red)
                    Text("18+ Sources (NSFW)").foregroundColor(.red).fontWeight(.bold)
                }) {
                    ForEach(nsfwSources) { source in
                        HStack {
                            Image(systemName: source.iconName)
                                .foregroundColor(.red)
                                .frame(width: 24)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(source.displayName).font(.headline)
                                    Text(source.tag).font(.caption2.bold()).foregroundColor(.red)
                                }
                                Text(source.description).font(.caption).foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Toggle("", isOn: Binding(
                                get: { viewModel.isSourceEnabled(source) },
                                set: { _ in viewModel.toggleSourceEnabled(source) }
                            ))
                            .labelsHidden()
                        }
                    }
                }
            }
            
            Section(header: Text("Custom JSON API Sources")) {
                if viewModel.customSources.isEmpty {
                    Text("No custom sources added yet. Tap \"Add Custom Source\" to connect any anime image API.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.customSources) { custom in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(custom.name).font(.headline)
                            Text(custom.endpointURL).font(.caption).foregroundColor(.secondary)
                        }
                    }
                    .onDelete { indices in
                        viewModel.customSources.remove(atOffsets: indices)
                        viewModel.saveCustomSources()
                    }
                }
                
                Button(action: { showAddSheet = true }) {
                    Label("Add Custom Source (JSON API)", systemImage: "plus.circle.fill")
                        .foregroundColor(.pink)
                }
            }
        }
        .navigationTitle("Source Manager")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddSheet) {
            NavigationView {
                Form {
                    Section(header: Text("API Parameters")) {
                        TextField("Name (e.g. Safebooru)", text: $newName)
                        TextField("URL (https://.../api/random)", text: $newURL)
                            .autocapitalization(.none)
                            .keyboardType(.URL)
                        TextField("JSON Image Key (e.g. url, file_url)", text: $newKeyPath)
                            .autocapitalization(.none)
                    }
                }
                .navigationTitle("New Source")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { showAddSheet = false }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            if !newName.isEmpty && !newURL.isEmpty {
                                viewModel.customSources.append(
                                    CustomSourceItem(name: newName, endpointURL: newURL, jsonKeyPath: newKeyPath)
                                )
                                viewModel.saveCustomSources()
                                showAddSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Proxy Settings View with Live Diagnostics & Full Auth

struct ProxySettingsView: View {
    @ObservedObject var viewModel: AnimeGenViewModel
    
    @State private var proxyHost: String = ""
    @State private var proxyPort: String = "8080"
    @State private var isEnabled: Bool = false
    @State private var isSOCKS: Bool = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    
    // Live Diagnostics State
    @State private var isTesting: Bool = false
    @State private var testStatus: String? = nil
    @State private var testIsSuccess: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Proxy Status")) {
                Toggle("Enable Proxy", isOn: $isEnabled)
                    .onChange(of: isEnabled) { _ in saveCurrentProxy() }
                
                if isEnabled {
                    Picker("Protocol", selection: $isSOCKS) {
                        Text("HTTP / HTTPS").tag(false)
                        Text("SOCKS5").tag(true)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: isSOCKS) { _ in saveCurrentProxy() }
                }
            }
            
            if isEnabled {
                Section(header: Text("Connection Settings")) {
                    TextField("Host / IP (e.g. 192.168.1.1)", text: $proxyHost)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: proxyHost) { _ in saveCurrentProxy() }
                    
                    TextField("Port (e.g. 8080 or 1080)", text: $proxyPort)
                        .keyboardType(.numberPad)
                        .onChange(of: proxyPort) { _ in saveCurrentProxy() }
                }
                
                Section(header: Text("Authentication (Optional)")) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onChange(of: username) { _ in saveCurrentProxy() }
                    
                    HStack {
                        if showPassword {
                            TextField("Password", text: $password)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .onChange(of: password) { _ in saveCurrentProxy() }
                        } else {
                            SecureField("Password", text: $password)
                                .onChange(of: password) { _ in saveCurrentProxy() }
                        }
                        
                        Button(action: { showPassword.toggle() }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section(header: Text("Connection Test")) {
                    Button(action: runProxyTest) {
                        HStack {
                            if isTesting {
                                ProgressView()
                                    .scaleEffect(0.9)
                                    .padding(.trailing, 4)
                                Text("Testing connection...")
                            } else {
                                Image(systemName: "bolt.horizontal.circle.fill")
                                    .foregroundColor(.pink)
                                Text("Test Proxy (Ping & IP)")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .disabled(isTesting || proxyHost.isEmpty)
                    
                    if let status = testStatus {
                        HStack(spacing: 8) {
                            Image(systemName: testIsSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(testIsSuccess ? .green : .red)
                            Text(status)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(testIsSuccess ? .green : .red)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            
            Section(header: Text("Information")) {
                Text("Proxy routes all network requests and image downloads through a secure server.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Proxy Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let current = viewModel.proxyConfig
            self.isEnabled = current.isEnabled
            self.proxyHost = current.host
            self.proxyPort = "\(current.port)"
            self.isSOCKS = current.isSOCKS
            self.username = current.username
            self.password = current.password
        }
        .onDisappear {
            saveCurrentProxy()
        }
    }
    
    private func saveCurrentProxy() {
        let portInt = Int(proxyPort) ?? 8080
        viewModel.proxyConfig = ProxyConfig(
            isEnabled: isEnabled,
            host: proxyHost.trimmingCharacters(in: .whitespacesAndNewlines),
            port: portInt,
            isSOCKS: isSOCKS,
            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        viewModel.saveProxySettings()
    }
    
    private func runProxyTest() {
        isTesting = true
        testStatus = nil
        let portInt = Int(proxyPort) ?? 8080
        let testConfig = ProxyConfig(
            isEnabled: true,
            host: proxyHost.trimmingCharacters(in: .whitespacesAndNewlines),
            port: portInt,
            isSOCKS: isSOCKS,
            username: username.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        
        Task {
            do {
                let result = try await AppNetworkManager.testProxy(config: testConfig)
                await MainActor.run {
                    self.isTesting = false
                    self.testIsSuccess = true
                    self.testStatus = "🟢 Proxy active! Latency: \(Int(result.latency))ms, Public IP: \(result.ip)"
                }
            } catch {
                await MainActor.run {
                    self.isTesting = false
                    self.testIsSuccess = false
                    self.testStatus = "🔴 Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

// MARK: - Source Picker Sheet

struct SourcePickerSheet: View {
    @ObservedObject var viewModel: AnimeGenViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                let sfwSources = ImageSource.allCases.filter { !$0.isNSFW && $0 != .waifuIm && viewModel.isSourceEnabled($0) }
                Section(header: Text("Standard Sources (SFW)").font(.caption)) {
                    ForEach(sfwSources) { source in
                        sourceRow(for: source)
                    }
                    
                    // Waifu.im in maintenance
                    Button(action: {
                        viewModel.showToast("Waifu.im is under maintenance (Cloudflare protection) ⚠️")
                    }) {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.12))
                                    .frame(width: 38, height: 38)
                                Image(systemName: "wrench.and.screwdriver.fill")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text("Waifu.im")
                                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                                        .foregroundColor(.secondary)
                                    
                                    Text("Maintenance ⚠️")
                                        .font(.system(size: 9, weight: .bold, design: .rounded))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.orange.opacity(0.15), in: Capsule())
                                        .foregroundColor(.orange)
                                }
                                
                                Text("Temporarily disabled for maintenance (Cloudflare)")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "lock.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 4)
                        .opacity(0.65)
                    }
                }
                
                if viewModel.isNSFWEnabled {
                    let nsfwSources = ImageSource.allCases.filter { $0.isNSFW && viewModel.isSourceEnabled($0) }
                    Section(header: HStack {
                        Image(systemName: "flame.fill").foregroundColor(.red)
                        Text("18+ Sources (NSFW)").font(.caption).foregroundColor(.red).fontWeight(.bold)
                    }) {
                        ForEach(nsfwSources) { source in
                            sourceRow(for: source)
                        }
                    }
                }
            }
            .navigationTitle("Sources")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
    
    @ViewBuilder
    private func sourceRow(for source: ImageSource) -> some View {
        Button(action: {
            viewModel.setSource(source)
            dismiss()
        }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(source.isNSFW ? Color.red.opacity(0.2) : (source == viewModel.selectedSource ? Color.pink.opacity(0.2) : Color.gray.opacity(0.15)))
                        .frame(width: 38, height: 38)
                    Image(systemName: source.iconName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(source.isNSFW ? .red : (source == viewModel.selectedSource ? .pink : .secondary))
                }
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(source.displayName)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(Color(UIColor.label))
                        
                        Text(source.tag)
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(source.isNSFW ? Color.red.opacity(0.2) : (source == .waifupics ? Color.pink.opacity(0.2) : Color.blue.opacity(0.15)), in: Capsule())
                            .foregroundColor(source.isNSFW ? .red : (source == .waifupics ? .pink : .blue))
                    }
                    
                    Text(source.description)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if source == viewModel.selectedSource {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(source.isNSFW ? .red : .pink)
                        .font(.system(size: 20))
                }
            }
            .padding(.vertical, 4)
        }
    }
}

// MARK: - Gallery & Favorites View

struct GalleryView: View {
    let title: String
    let items: [AnimeArtItem]
    let onSelect: (AnimeArtItem) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]
    
    var body: some View {
        Group {
            if items.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No saved art yet")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(items.reversed()) { item in
                            Button(action: {
                                onSelect(item)
                            }) {
                                KFImage(item.imageURL)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 180)
                                    .clipped()
                                    .cornerRadius(14)
                                    .overlay(
                                        VStack {
                                            Spacer()
                                            HStack {
                                                Text(item.source.displayName)
                                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                                    .padding(.horizontal, 6)
                                                    .padding(.vertical, 3)
                                                    .background(.ultraThinMaterial, in: Capsule())
                                                    .foregroundColor(Color(UIColor.label))
                                                Spacer()
                                            }
                                            .padding(6)
                                        }
                                    )
                            }
                        }
                    }
                    .padding(14)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Hidden Debug Console View with Pastebin Log Sharing

struct DebugConsoleView: View {
    @ObservedObject var viewModel: AnimeGenViewModel
    @ObservedObject var logger: DebugLogger
    
    @State private var pingResults: [String: String] = [:]
    @State private var isPinging: Bool = false
    @State private var isSharingPastebin: Bool = false
    @State private var filterErrorsOnly: Bool = false
    
    var filteredLogs: [DebugLogEntry] {
        if filterErrorsOnly {
            return logger.logs.filter { $0.isError }
        }
        return logger.logs
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Quick Action Bar
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Button(action: pingAllSources) {
                        HStack(spacing: 4) {
                            Image(systemName: isPinging ? "waveform.path.ecg" : "bolt.horizontal.fill")
                            Text(isPinging ? "Testing..." : "Test APIs")
                        }
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(Color.blue.opacity(0.15), in: Capsule())
                        .foregroundColor(.blue)
                    }
                    .disabled(isPinging)
                    
                    Button(action: shareLogsViaPastebin) {
                        HStack(spacing: 4) {
                            if isSharingPastebin {
                                ProgressView().scaleEffect(0.7)
                            } else {
                                Image(systemName: "square.and.arrow.up.fill")
                            }
                            Text(isSharingPastebin ? "Uploading..." : "Share (Pastebin)")
                        }
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 9)
                        .padding(.vertical, 6)
                        .background(Color.pink.opacity(0.15), in: Capsule())
                        .foregroundColor(.pink)
                    }
                    .disabled(isSharingPastebin)
                    
                    Spacer()
                    
                    Button(action: {
                        UIPasteboard.general.string = logger.allLogsFormatted
                        viewModel.showToast("Logs copied! 📋")
                    }) {
                        Image(systemName: "doc.on.doc.fill")
                            .font(.system(size: 12))
                            .padding(7)
                            .background(Color.green.opacity(0.15), in: Circle())
                            .foregroundColor(.green)
                    }
                    
                    Button(action: { viewModel.clearCache() }) {
                        Image(systemName: "trash.fill")
                            .font(.system(size: 12))
                            .padding(7)
                            .background(Color.orange.opacity(0.15), in: Circle())
                            .foregroundColor(.orange)
                    }
                    
                    Button(action: { logger.clear() }) {
                        Image(systemName: "xmark.bin.fill")
                            .font(.system(size: 12))
                            .padding(7)
                            .background(Color.red.opacity(0.15), in: Circle())
                            .foregroundColor(.red)
                    }
                }
                
                Toggle(isOn: $filterErrorsOnly) {
                    Text("Show errors only")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(UIColor.secondarySystemBackground))
            
            // Ping Results List
            if !pingResults.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Source Status:")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(pingResults.keys.sorted()), id: \.self) { key in
                                let val = pingResults[key] ?? ""
                                HStack(spacing: 4) {
                                    Text(key).font(.system(size: 10, weight: .bold))
                                    Text(val).font(.system(size: 10, design: .monospaced))
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(val.contains("❌") ? Color.red.opacity(0.15) : Color.green.opacity(0.15), in: Capsule())
                                .foregroundColor(val.contains("❌") ? .red : .green)
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(Color(UIColor.tertiarySystemBackground))
            }
            
            // Real-time Logs List
            if filteredLogs.isEmpty {
                VStack(spacing: 8) {
                    Spacer()
                    Image(systemName: "terminal")
                        .font(.system(size: 36))
                        .foregroundColor(.secondary)
                    Text("No debug logs recorded")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            } else {
                List {
                    ForEach(filteredLogs.reversed()) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(entry.timeString)
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(.secondary)
                                
                                Text(entry.tag)
                                    .font(.system(size: 10, weight: .black, design: .rounded))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(entry.isError ? Color.red.opacity(0.2) : Color.blue.opacity(0.15), in: Capsule())
                                    .foregroundColor(entry.isError ? .red : .blue)
                                
                                Spacer()
                            }
                            
                            Text(entry.message)
                                .font(.system(size: 12, weight: .medium, design: .monospaced))
                                .foregroundColor(entry.isError ? .red : Color(UIColor.label))
                            
                            if let details = entry.details, !details.isEmpty {
                                Text(details)
                                    .font(.system(size: 10, design: .monospaced))
                                    .foregroundColor(.secondary)
                                    .lineLimit(3)
                            }
                        }
                        .padding(.vertical, 2)
                    }
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("Debug Console")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shareLogsViaPastebin() {
        isSharingPastebin = true
        let logContent = """
        === AnimeGen Debug Logs ===
        Date: \(Date())
        Proxy: \(viewModel.proxyConfig.isEnabled ? "\(viewModel.proxyConfig.isSOCKS ? "SOCKS5" : "HTTP") \(viewModel.proxyConfig.host):\(viewModel.proxyConfig.port)" : "Disabled")
        
        \(logger.allLogsFormatted)
        """
        
        Task {
            guard let url = URL(string: "https://paste.rs") else { return }
            var req = URLRequest(url: url)
            req.httpMethod = "POST"
            req.httpBody = logContent.data(using: .utf8)
            req.timeoutInterval = 10.0
            
            do {
                let (data, response) = try await URLSession.shared.data(for: req)
                if let httpResp = response as? HTTPURLResponse, (200...299).contains(httpResp.statusCode),
                   let rawURL = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                   let pasteURL = URL(string: rawURL) {
                    await MainActor.run {
                        self.isSharingPastebin = false
                        UIPasteboard.general.string = rawURL
                        viewModel.showToast("Link created and copied! 🔗")
                        presentShareSheet(items: [rawURL, pasteURL])
                    }
                    return
                }
                throw URLError(.badServerResponse)
            } catch {
                await MainActor.run {
                    self.isSharingPastebin = false
                    UIPasteboard.general.string = logContent
                    viewModel.showToast("Logs copied to clipboard (network error)")
                    presentShareSheet(items: [logContent])
                }
            }
        }
    }
    
    private func pingAllSources() {
        isPinging = true
        pingResults.removeAll()
        
        let testable = ImageSource.allCases.filter { $0 != .random }
        Task {
            await withTaskGroup(of: (String, String).self) { group in
                for source in testable {
                    group.addTask {
                        let t0 = CFAbsoluteTimeGetCurrent()
                        do {
                            switch source {
                            case .nekosBest: _ = try await NekosBestAPI.fetch(orientation: viewModel.orientationMode)
                            case .picRe: _ = try await PicReAPI.fetch(orientation: viewModel.orientationMode)
                            case .nekoBot: _ = try await NekoBotAPI.fetch(orientation: viewModel.orientationMode)
                            case .nekosApi: _ = try await NekosApiAPI.fetch()
                            case .nekosLife: _ = try await NekosLifeAPI.fetch(orientation: viewModel.orientationMode)
                            case .nekosMoe: _ = try await NekosMoeAPI.fetch()
                            case .purr: _ = try await PurrAPI.fetch(orientation: viewModel.orientationMode)
                            case .waifupics: _ = try await WaifuPicsAPI.fetch(orientation: viewModel.orientationMode)
                            case .waifuIm: _ = try await WaifuImAPI.fetch()
                            case .nekoBotHentai: _ = try await NekoBotNSFWAPI.fetch(isGIFOnly: false)
                            case .nekoBotNSFWGIF: _ = try await NekoBotNSFWAPI.fetch(isGIFOnly: true)
                            case .purrNSFW: _ = try await PurrBotNSFWAPI.fetch()
                            case .danbooruNSFW: _ = try await DanbooruAPI.fetch(isNSFW: true)
                            case .random: break
                            }
                            let ms = Int((CFAbsoluteTimeGetCurrent() - t0) * 1000)
                            return (source.displayName, "\(ms)ms ✅")
                        } catch {
                            return (source.displayName, "❌")
                        }
                    }
                }
                
                for await (name, result) in group {
                    pingResults[name] = result
                }
            }
            isPinging = false
        }
    }
}

// MARK: - Global Share Sheet Helper

func presentShareSheet(items: [Any]) {
    guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController ?? windowScene.windows.first?.rootViewController else { return }
    
    var presenter = rootVC
    while let presented = presenter.presentedViewController {
        presenter = presented
    }
    
    let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
    if let popover = activityVC.popoverPresentationController {
        popover.sourceView = presenter.view
        popover.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
        popover.permittedArrowDirections = []
    }
    presenter.present(activityVC, animated: true)
}

// MARK: - UIKit ViewController Bridge

public class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var refreshButton: UIButton?
    @IBOutlet weak var heartButton: UIButton?
    @IBOutlet weak var rewindButton: UIButton?
    @IBOutlet weak var safariButton: UIButton?
    @IBOutlet weak var sourceButton: UIButton?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        view.subviews.forEach { $0.isHidden = true }
        
        let hostingController = UIHostingController(rootView: ModernContentView())
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {}
    @IBAction func refreshButtonTapped(_ sender: UIButton) {}
    @IBAction func rewindButtonTapped(_ sender: UIButton) {}
    @IBAction func heartButtonTapped(_ sender: UIButton) {}
}
