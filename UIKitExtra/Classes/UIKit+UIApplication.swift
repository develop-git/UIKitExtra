//
//  UIKit+UIApplication.swift
//  UIKitExtensions
//
//  Created by jian on 2025/7/15.
//

import UIKit

public extension UIApplication {
    var rootViewController: UIViewController? {
        
        if #available(iOS 13.0, *) {
            let keyWindow = connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .first(where: { $0.isKeyWindow })
            return keyWindow?.rootViewController
        } else {
            return keyWindow?.rootViewController
        }
    }

    static var appVersion: String {
        // swiftlint:disable no_hardcoded_strings
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        // swiftlint:enable no_hardcoded_strings
    }

    var isRunningUnitTests: Bool {
        // swiftlint:disable no_hardcoded_strings
        return NSClassFromString("XCTestCase") != nil
        // swiftlint:enable no_hardcoded_strings
    }
}
