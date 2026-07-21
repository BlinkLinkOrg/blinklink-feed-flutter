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

// MARK: - Screen

final class BLScreenViewFactory: NSObject, FlutterPlatformViewFactory {
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }

    func create(withFrame _: CGRect, viewIdentifier _: Int64, arguments args: Any?) -> FlutterPlatformView {
        let screenId = creationArgs(args)["screenId"] as? String ?? "inspire"
        let container = BLVCContainerView {
            let id: BLScreenID
            switch screenId {
            case "inspire": id = .inspire
            case "videos": id = .videos
            default: id = .custom(screenId)
            }
            return Blinklink.screenViewController(id: id)
        }
        return BLWrappedPlatformView(contained: container)
    }
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
