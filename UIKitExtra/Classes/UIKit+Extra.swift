//
//  UIKit+Extra.swift
//  Foundation-Extra
//
//  Created by jian on 2023/9/20.
//

import Foundation

public struct UIKitSetting<Base> {
    let base: Base
    init(_ base: Base) { self.base = base }
}

public protocol UIKitSettingCompatible {}
public extension UIKitSettingCompatible {
    static var set: UIKitSetting<Self>.Type {
        get { UIKitSetting<Self>.self }
        set {}
    }
    var set: UIKitSetting<Self> {
        get { UIKitSetting(self) }
        set {}
    }
}

extension UIView : UIKitSettingCompatible {}
extension UIViewController : UIKitSettingCompatible {}

public struct ListViewProxy : OptionSet, Equatable {
    public let rawValue: Int
    public init(rawValue: Int) {self.rawValue = rawValue}
    /// 方法代理
    public static let delegate = ListViewProxy(rawValue: 1 << 0)
    /// 数据源代理
    public static let dataSource = ListViewProxy(rawValue: 1 << 1)
    /// 方法、数据源
    public static let all = ListViewProxy(rawValue: 3)
}

