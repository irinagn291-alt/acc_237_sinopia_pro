import UIKit
import Alamofire
import OneSignalFramework

final class AppDelegate: NSObject, UIApplicationDelegate {
    private static let bind = "com.sinopialeaf.press"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = Self.bind
        APIConfig.apply()
        OneSignal.initialize("225a0bd6-1a13-4724-9fac-870ccb396269", withLaunchOptions: launchOptions)
        OneSignal.Notifications.requestPermission({ @Sendable _ in }, fallbackToSettings: false)
        application.registerForRemoteNotifications()
        return true
    }
}
