@objc (BrightcoveViewManager)
class BrightcoveViewManager: RCTViewManager {

  override static func requireMainQueueSetup() -> Bool {
    return true
  }

  override func view() -> UIView! {
    return ViewController()
  }
}