//
//  UIBezierPath+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//


// MARK: ------ UIBezierPath --------
public extension UIBezierPath {
    
    /// 创建bezierPath
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - rect: 绘制区域
    @discardableResult
    static func path(with radius: CGFloat, in rect: CGRect) -> UIBezierPath {
        UIBezierPath(roundedRect: rect, cornerRadius: radius)
    }
    
    /// 创建bezierPath
    /// - Parameters:
    ///   - radii: 圆角设置(width\height)
    ///   - corners: 需设置的角
    ///   - rect: 绘制区域
    @discardableResult
    static func path(with radii: CGSize, for corners: UIRectCorner, in rect: CGRect) -> UIBezierPath {
        UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: radii)
    }
    
    /// 创建bezierPath
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - corners: 需设置的角
    ///   - rect: 绘制区域
    @discardableResult
    static func path(with radius: CGFloat, for corners: UIRectCorner, in rect: CGRect) -> UIBezierPath {
        UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    }
    
    struct Radius {
        
        var topLeft: Double
        var bottomLeft: Double
        var bottomRight: Double
        var topRight: Double
        
        /// 初始化Bezierpath Radius
        /// - Parameters:
        ///   - topLeftRadius:      左上角圆角大小
        ///   - bottomLeftRadius:   左下角圆角大小
        ///   - bottomRightRadius:  右下角圆角大小
        ///   - topRightRadius:     右上角圆角大小
        init(tl topLeftRadius: Double, bl bottomLeftRadius: Double, br bottomRightRadius: Double, tr topRightRadius: Double) {
            self.topLeft = topLeftRadius
            self.bottomLeft = bottomLeftRadius
            self.bottomRight = bottomRightRadius
            self.topRight = topRightRadius
        }
    }
    
    static func path(with radius: UIBezierPath.Radius, in rect: CGRect) -> UIBezierPath? {
        
        let path: UIBezierPath? = UIBezierPath()
        let pi = Double.pi
        
        let width = CGRectGetWidth(rect)
        let height = CGRectGetHeight(rect)
        
        /// 顺时针绘制 右上->右下->左下->左上
        path?.move(to: CGPoint(x: width - radius.topRight, y: 0))
        path?.addArc(withCenter: CGPoint(x: width - radius.topRight, y: radius.topRight), radius: radius.topRight, startAngle: pi * 1.5, endAngle: pi * 2, clockwise: true)

        path?.addLine(to: CGPoint(x: width, y: height - radius.bottomRight))
        path?.addArc(withCenter: CGPoint(x: width - radius.bottomRight, y: height - radius.bottomRight), radius:radius.bottomRight, startAngle: pi * 2, endAngle: pi * 0.5, clockwise: true)

        path?.addLine(to: CGPoint(x: radius.bottomLeft, y: height))
        path?.addArc(withCenter: CGPoint(x: radius.bottomLeft, y: height - radius.bottomLeft), radius: radius.bottomLeft, startAngle: pi * 0.5, endAngle: pi, clockwise: true)

        path?.addLine(to: CGPoint(x: 0, y: radius.topLeft))
        path?.addArc(withCenter: CGPoint(x: radius.topLeft, y: radius.topLeft), radius: radius.topLeft, startAngle: pi, endAngle: pi * 1.5, clockwise: true)
        
        path?.close()
        return path
    }
}
