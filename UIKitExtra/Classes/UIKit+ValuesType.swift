//
//  UIKit+ValuesType+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/27.
//



// MARK: ----- UIStatusBarStyle ------
#if os(iOS)
public extension UIStatusBarStyle {
    
    /// 黑色状态栏
    static var dark: UIStatusBarStyle {
        get {
            if #available(iOS 13.0, *) {
                return .darkContent
            } else {
                return .default
            }
        }
    }
    
    /// 白色状态栏
    static var light: UIStatusBarStyle {
        get { .lightContent }
    }
}
#endif

public extension UIEdgeInsets {
    
    init(horz: CGFloat, vert: CGFloat) {
        self.init(top: vert, left: horz, bottom: vert, right: horz)
    }
    
    init(_ len: CGFloat = 0.0) {
        self.init(top: len, left: len, bottom: len, right: len)
    }
}


public extension UIRectEdge {
    
    static var untop: UIRectEdge {
        get { [.left, .bottom, .right] }
    }
    
    static var unleft: UIRectEdge {
        get { [.top, .bottom, .right] }
    }
    
    static var unbottom: UIRectEdge {
        get { [.top, .left, .right] }
    }
    
    static var unright: UIRectEdge {
        get { [.top, .left, .bottom] }
    }
    
    static var horz: UIRectEdge {
        get { [.left, .right] }
    }
    
    static var vert: UIRectEdge {
        get { [.top, .bottom] }
    }
}


// MARK: ----- RectCorner -----

public extension UIRectCorner {
    static var tops: UIRectCorner {
        get { [.topLeft, .topRight] }
    }
    
    static var untopLeft: UIRectCorner {
        get { [.bottoms, .topRight] }
    }
    
    static var untopRight: UIRectCorner {
        get { [.bottoms, .topLeft] }
    }
    
    static var bottoms: UIRectCorner {
        get { [.bottomLeft, .bottomRight] }
    }
    
    static var unbottomLeft: UIRectCorner {
        get { [.tops, .bottomRight] }
    }
    
    static var unbottomRight: UIRectCorner {
        get { [.tops, .bottomLeft] }
    }
    
    static var lefts: UIRectCorner {
        get { [.topLeft, .bottomLeft] }
    }
    
    static var rights: UIRectCorner {
        get { [.topRight, .bottomRight] }
    }
    
    static var diagonal: UIRectCorner {
        get {[.topLeft, .bottomRight]}
    }
    
    static var subdiagonal: UIRectCorner {
        get {[.bottomLeft, .topRight]}
    }
}
