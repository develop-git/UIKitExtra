//
//  UIKit+Gradient.swift
//  Foundation-Extra
//
//  Created by jian on 2023/9/20.
//

import Foundation

public struct UnitPoint {
    var x: CGFloat, y: CGFloat
    init() {
        self.x = 0; self.y = 0
    }

    init(x: CGFloat, y: CGFloat) {
        self.x = x; self.y = y
    }
}

public protocol GradientPoint {
    var startPoint: CGPoint { get }
    var endPoint: CGPoint { get }
}

extension CGPoint: GradientPoint {
    public var startPoint: CGPoint { self }
    public var endPoint: CGPoint { self }
}

extension UnitPoint: GradientPoint {
    public var startPoint: CGPoint { CGPoint(x: self.x, y: self.y) }
    public var endPoint: CGPoint { CGPoint(x: self.x, y: self.y) }
}

public extension GradientPoint where Self == UnitPoint {
    static var center: UnitPoint { UnitPoint(x: 0.5, y: 0.5) }
    static var leading: UnitPoint { UnitPoint(x: 0.0, y: 0.5) }
    static var trailing: UnitPoint { UnitPoint(x: 1.0, y: 0.5) }
    static var top: UnitPoint { UnitPoint(x: 0.5, y: 0.0) }
    static var bottom: UnitPoint { UnitPoint(x: 0.5, y: 1.0) }
    static var topLeading: UnitPoint { UnitPoint(x: 0.0, y: 0.0) }
    static var topTrailing: UnitPoint { UnitPoint(x: 1.0, y: 0.0) }
    static var bottomLeading: UnitPoint { UnitPoint(x: 0.0, y: 1.0) }
    static var bottomTrailing: UnitPoint { UnitPoint(x: 1.0, y: 1.0) }
}
