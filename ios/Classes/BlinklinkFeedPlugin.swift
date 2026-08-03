import BlinklinkFeed
import Flutter
import UIKit

public class BlinklinkFeedPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    static var actionSink: FlutterEventSink?
    static var interceptedTypes = Set<String>()

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "blinklink_feed",
            binaryMessenger: registrar.messenger()
        )
        let instance = BlinklinkFeedPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

        FlutterEventChannel(
            name: "blinklink_feed/actions",
            binaryMessenger: registrar.messenger()
        ).setStreamHandler(instance)

        registrar.register(BLFeedViewFactory(), withId: "blinklink_feed/feed")
        registrar.register(BLSuperFeedViewFactory(), withId: "blinklink_feed/superfeed")
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]
        switch call.method {
        case "initialize":
            Self.interceptedTypes = Set(args["interceptActions"] as? [String] ?? [])
            let environment: BLEnvironment =
                (args["environment"] as? String) == "development" ? .development : .production
            Blinklink.configure(
                clientId: args["clientId"] as? String ?? "",
                environment: environment,
                stream: args["stream"] as? String ?? "videos",
                placement: args["placement"] as? String ?? "videos-tab"
            ) { action in
                let payload = Self.serialize(action)
                DispatchQueue.main.async { Self.actionSink?(payload) }
                let type = payload["type"] as? String ?? ""
                return Self.interceptedTypes.contains(type) ? .handled : .useDefault
            }
            result(nil)
        case "setUser":
            if let ref = args["ref"] as? String { Blinklink.setUser(ref: ref) }
            result(nil)
        case "clearUser":
            Blinklink.clearUser()
            result(nil)
        case "handleUniversalLink":
            guard let urlString = args["url"] as? String, let url = URL(string: urlString) else {
                result(false)
                return
            }
            result(Blinklink.handleUniversalLink(url))
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    static func serialize(_ action: BLAction) -> [String: Any] {
        switch action {
        case .openURL(let url):
            return ["type": "openURL", "url": url.absoluteString]
        case .navigate(let screenID, let params):
            return ["type": "navigate", "screenId": screenID, "params": params]
        case .openSheet(let kind, let contentID):
            return ["type": "openSheet", "kind": kind, "contentId": contentID]
        case .fireEvent(let name, let attributes):
            return ["type": "fireEvent", "name": name, "attributes": attributes]
        }
    }

    // MARK: - FlutterStreamHandler

    public func onListen(
        withArguments _: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
        Self.actionSink = events
        return nil
    }

    public func onCancel(withArguments _: Any?) -> FlutterError? {
        Self.actionSink = nil
        return nil
    }
}
