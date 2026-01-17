// import Flutter
// import UIKit
// import FirebaseCore

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }



import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import PushKit
import flutter_callkit_incoming

@main
@objc class AppDelegate: FlutterAppDelegate, PKPushRegistryDelegate {
  private var voipRegistry: PKPushRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    // ✅ Add these lines for APNs registration
    UNUserNotificationCenter.current().delegate = self
    application.registerForRemoteNotifications()

    // ✅ Register PushKit (VoIP) token for reliable CallKit on lock screen/terminated state.
    _setupVoipPushRegistry()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    // Ensure Firebase gets the APNs token and log it for debugging.
    Messaging.messaging().apnsToken = deviceToken
    let token = deviceToken.map { String(format: "%02x", $0) }.joined()
    NSLog("APNs device token: \(token)")
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("APNs registration failed: \(error)")
    super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
  }

  private func _setupVoipPushRegistry() {
    let registry = PKPushRegistry(queue: DispatchQueue.main)
    registry.delegate = self
    registry.desiredPushTypes = [.voIP]
    voipRegistry = registry
  }

  private func _looksLikeUuid(_ value: String) -> Bool {
    return UUID(uuidString: value) != nil
  }

  // MARK: - PushKit (VoIP)

  func pushRegistry(
    _ registry: PKPushRegistry,
    didUpdate pushCredentials: PKPushCredentials,
    for type: PKPushType
  ) {
    guard type == .voIP else { return }
    let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didInvalidatePushTokenFor type: PKPushType
  ) {
    guard type == .voIP else { return }
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
  }

  func pushRegistry(
    _ registry: PKPushRegistry,
    didReceiveIncomingPushWith payload: PKPushPayload,
    for type: PKPushType,
    completion: @escaping () -> Void
  ) {
    guard type == .voIP else {
      completion()
      return
    }

    let args = _extractCallkitArgs(from: payload.dictionaryPayload)
    guard !args.isEmpty else {
      completion()
      return
    }

    let callData = flutter_callkit_incoming.Data(args: args)
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.showCallkitIncoming(
      callData,
      fromPushKit: true,
      completion: completion
    )
  }

  private func _extractCallkitArgs(from raw: [AnyHashable: Any]) -> [String: Any] {
    func toStringKeyed(_ any: Any) -> [String: Any]? {
      if let dict = any as? [String: Any] { return dict }
      if let dict = any as? [AnyHashable: Any] {
        var out: [String: Any] = [:]
        for (k, v) in dict {
          if let ks = k as? String { out[ks] = v }
        }
        return out
      }
      return nil
    }

    // Many backends wrap custom data under `data` or `callkit`.
    let root = toStringKeyed(raw) ?? [:]
    let nested =
      toStringKeyed(root["data"] as Any) ??
      toStringKeyed(root["callkit"] as Any) ??
      root

    var args = nested

    // Normalize common key variants to plugin expected keys.
    if args["id"] == nil, let uuid = args["uuid"] as? String {
      args["id"] = uuid
    }
    if args["nameCaller"] == nil, let name = args["name"] as? String {
      args["nameCaller"] = name
    }
    if args["handle"] == nil {
      if let appointmentType = (args["appointmentType"] as? String) ?? (args["typeLabel"] as? String) {
        args["handle"] = appointmentType
      }
    }

    // Hard-require minimal fields for CallKit UI.
    let id = (args["id"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    let nameCaller = (args["nameCaller"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    let handle = (args["handle"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    if id.isEmpty || nameCaller.isEmpty || handle.isEmpty {
      return [:]
    }

    if !_looksLikeUuid(id) {
      let newId = UUID().uuidString
      let originalId = id
      args["id"] = newId
      args["uuid"] = newId
      var extra = toStringKeyed(args["extra"] as Any) ?? [:]
      if extra["appointmentId"] == nil && !originalId.isEmpty {
        extra["appointmentId"] = originalId
      }
      args["extra"] = extra
    }
    return args
  }
}
