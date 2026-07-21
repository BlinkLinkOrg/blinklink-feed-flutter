import UIKit

/// Hosts a UIViewController inside a plain UIView with proper child-VC
/// containment, so appearance callbacks (viewWillAppear etc.) fire — the
/// Blinklink player relies on them. The VC is created lazily on first
/// attach to a window (the responder chain has no parent VC until attach —
/// for Flutter platform views the parent resolves to FlutterViewController).
final class BLVCContainerView: UIView {
    private let makeVC: () -> UIViewController
    private var hosted: UIViewController?

    init(makeVC: @escaping () -> UIViewController) {
        self.makeVC = makeVC
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) { fatalError("init(coder:) is not supported") }

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else {
            teardown()
            return
        }
        guard hosted == nil, let parent = findParentViewController() else { return }
        let vc = makeVC()
        parent.addChild(vc)
        addSubview(vc.view)
        vc.view.frame = bounds
        vc.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        vc.didMove(toParent: parent)
        hosted = vc
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        hosted?.view.frame = bounds
    }

    private func teardown() {
        guard let vc = hosted else { return }
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
        hosted = nil
    }

    private func findParentViewController() -> UIViewController? {
        var responder: UIResponder? = next
        while let current = responder {
            if let vc = current as? UIViewController { return vc }
            responder = current.next
        }
        return nil
    }
}
