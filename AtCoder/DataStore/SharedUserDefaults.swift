import Foundation

struct SharedUserDefaults {
    private static let userDefault = UserDefaults(suiteName: "group.shota.kashihara.atcoder")

    static var userId: String? {
        get {
            return userDefault?.string(forKey: "userId")
        }
        set {
            userDefault?.setValue(newValue, forKey: "userId")
        }
    }
}
