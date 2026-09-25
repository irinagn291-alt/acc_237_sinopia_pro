import Foundation

/// UserDefaults keys. Content never lives here; only preferences and the demo seed flag.
public enum PreferenceKeys {
    public static let demoSeed = "snp.demo.v1"
    public static let onboardingComplete = "snp.onboarding.complete"
    public static let hapticsEnabled = "snp.prefs.haptics"
    public static let exportFormat = "snp.prefs.export"
}
