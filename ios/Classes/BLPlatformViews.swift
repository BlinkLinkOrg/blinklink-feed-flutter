import BlinklinkFeed
import Flutter
import UIKit

private final class BLWrappedPlatformView: NSObject, FlutterPlatformView {
    private let contained: UIView

    init(contained: UIView) {
        self.contained = contained
        super.init()
    }

    func view() -> UIView { contained }
}

private func creationArgs(_ args: Any?) -> [String: Any] {
    args as? [String: Any] ?? [:]
}

// MARK: - Referrer feed

final class BLFeedViewFactory: NSObject, FlutterPlatformViewFactory {
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame _: CGRect, viewIdentifier _: Int64, arguments args: Any?) -> FlutterPlatformView {
        let params = creationArgs(args)
        let layout: BLFeedLayout
        switch params["layout"] as? String {
        case "carousel3D": layout = .carousel3D
        case "grid": layout = .grid
        default: layout = .carousel
        }
        let feedView = BLReferrerFeedView(layout: layout, title: params["title"] as? String)
        return BLWrappedPlatformView(contained: feedView)
    }
}

// MARK: - SuperFeed

final class BLSuperFeedViewFactory: NSObject, FlutterPlatformViewFactory {
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame _: CGRect, viewIdentifier _: Int64, arguments _: Any?) -> FlutterPlatformView {
        BLWrappedPlatformView(contained: BLVCContainerView { BLSuperFeedViewController() })
    }
}
