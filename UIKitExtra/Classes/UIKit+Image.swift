//
//  UIImage+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ------ UIImage ------
// MARK: 图片初始化
public extension UIImage {
    /// 初始化一张图片
    /// - Parameter named: 图片资源名
    /// - Returns: 图片
    @discardableResult
   convenience init?(_ named: String?) {
        self.init(named: named ?? "")
    }
    
    /// 初始化一张图片
    /// - Parameter named: 图片资源名
    /// - Returns: 图片
    @discardableResult
    static func make(srcStr named: String?) -> UIImage? {
        UIImage(named)
    }
}
// MARK: 重绘图片圆角、尺寸，绘制渐变图片，根据颜色生成图片等
public extension UIKitSetting where Base : UIImage {
    
    @discardableResult
    func opacity(_ opacity: CGFloat) -> UIImage {
        return UIKitSetting.renderImage(size: base.size, opaque: false, scale: base.scale) { ctx in
            base.draw(in: CGRect(origin: .zero, size: base.size), blendMode: .normal, alpha: opacity)
        }!
    }
    
    /// 将图片重新绘制成带形状的图片
    /// - Parameters:
    ///   - shape: 需要绘制的形状
    ///   - rect:  绘制区域
    @discardableResult
    func shape(with shape: Shape, in rect: CGRect) -> UIImage {
        
        /// 校检size合法性
        guard base.size.isValidated else { return self.base }
        
        /// 需设置圆角或边框 使用CoreGraphics绘制
        return UIGraphicsImageRenderer(bounds: rect).image { ctx in
            
            let path = shape.path(in: CGRect(origin: rect.origin, size: base.size))
            path.addClip()
            shape.fill(ctx: ctx.cgContext, path: path, style: base, size: base.size)
            shape.stroke(ctx: ctx.cgContext, path: path, strokeStyle: shape.strokeStyle)
        }
    }
    
    /// 重置图片尺寸
    /// - Parameter size: 压缩尺寸
    func size(with size: CGSize) -> UIImage {
        if self.base.size == size {
            return self.base
        }
        return UIGraphicsImageRenderer(size: size).image { ctx in
            self.base.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// 使用颜色生成一张图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - size:  图片的大小
    static func color(_ color: UIColor, in size: CGSize = CGSize(width: 4, height: 4)) -> UIImage? {
        return UIGraphicsImageRenderer(size: size).image { ctx in
            ctx.cgContext.setFillColor(color.cgColor)
            ctx.cgContext.fill(CGRect(origin: .zero, size: size))
        }
    }
    
    /// 使用颜色生成一张带形状的图片
    /// - Parameters:
    ///   - color: 颜色
    ///   - shape: 图片形状
    ///   - size:  图片的大小
    static func color(_ color: UIColor, shape: Shape, in size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { ctx in
            let path = shape.path(in: CGRect(origin: .zero, size: size))
            path.addClip()
            shape.fill(ctx: ctx.cgContext, path: path, style: color, size: size)
            shape.stroke(ctx: ctx.cgContext, path: path, strokeStyle: shape.strokeStyle)
        }
    }
    
    /// 使用CoreGraphics绘制图片
    /// - Parameters:
    ///   - size: 绘制尺寸
    ///   - opaque: 图片是否具有透明度透明度
    ///   - scale: 图片缩放大小
    ///   - action: 外部执行block，提供context，方便外部使用
    static func renderImage(size: CGSize, opaque: Bool, scale: CGFloat, action: ((CGContext)->Void)?) -> UIImage? {
        guard let action = action, size.isValidated else { return nil }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        format.opaque = opaque
        
        let render = UIGraphicsImageRenderer(size: size, format: format)
        return render.image{action($0.cgContext)}
    }
    
    /// 线性渐变图片
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - startPoint: 起始点
    ///   - endPoint: 结束点
    ///   - locations: 颜色位置数组，单调递增
    ///   - size: 图片尺寸
    ///   - path: 绘制路径
    @discardableResult
    static func linearGradient<StartPoint, EndPoint>(colors: [UIColor], start startPoint: StartPoint, end endPoint: EndPoint, locations: [CGFloat]? = nil, size: CGSize = CGSizeMake(4, 4), path: UIBezierPath? = nil) -> UIImage? where StartPoint : GradientPoint, EndPoint : GradientPoint {
        return UIKitSetting.renderImage(size: size, opaque: false, scale: 0) { ctx in
            if let path = path {
                path.addClip()
            }
            let spaceRef = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: spaceRef, colors: colors.map{$0.cgColor} as CFArray, locations: locations ?? [0, 1])
            guard let gradient = gradient else { return }
            
            let startPoint = startPoint.startPoint
            let endPoint = endPoint.endPoint
            
            ctx.drawLinearGradient(gradient,
                                   start: startPoint,
                                   end: endPoint,
                                   options: .drawsBeforeStartLocation)
        }
    }
    
    /// 圆形渐变图片
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - locations: 颜色位置数组，单调递增
    ///   - size: 图片尺寸
    ///   - path: 绘制路径
    @discardableResult
    static func radialGradient(colors: [UIColor], locations: [CGFloat]? = nil, size: CGSize = .init(width: 4, height: 4), path: UIBezierPath? = nil) -> UIImage? {
        return UIKitSetting.renderImage(size: size, opaque: false, scale: 0) { ctx in
            if let path = path {
                path.addClip()
            }
            let spaceRef = CGColorSpaceCreateDeviceRGB()
            let gradient = CGGradient(colorsSpace: spaceRef, colors: colors.map{$0.cgColor} as CFArray, locations: locations ?? [0, 1])
            guard let gradient = gradient else { return }
            
            let minVal = size.min()
            let radius = minVal / 2
            let horzRatio = size.width / minVal
            let vertRatio = size.height / minVal
            
            ctx.translateBy(x: -(horzRatio - 1) * size.width / 2, y: -(vertRatio - 1) * size.height / 2)
            // 缩放是为了让渐变的圆形可以按照 size 变成椭圆的
            ctx.scaleBy(x: horzRatio, y: vertRatio)
            ctx.drawRadialGradient(gradient,
                                   startCenter: CGPointMake(size.width / 2, size.height / 2),
                                   startRadius: 0,
                                   endCenter: CGPointMake(size.width / 2, size.height / 2),
                                   endRadius: radius,
                                   options: .drawsBeforeStartLocation)
        }
    }
}

// MARK: ------ 图片形状 -------
// MARK: ------ ShapeStyle Protocol ------
/// Shape类型协议
public protocol ShapeStyle {}

// MARK: ------ Shape Protocol ------
extension UIImage : ShapeStyle {}
extension UIColor : ShapeStyle {}

/// Shape绘制协议
public protocol Shape {
    /// 边框配置
    var strokeStyle: StrokeStyle? {set get}
    
    /// 绘制路径
    /// - Parameters:
    ///   - rect: 绘制区域
    func path(in rect: CGRect) -> UIBezierPath
    
    /// 边框绘制
    /// - Parameters:
    ///   - ctx:         图形上下文
    ///   - path:        绘制路径
    ///   - strokeStyle: 边框填充类型
    func stroke(ctx: CGContext, path: UIBezierPath, strokeStyle: StrokeStyle?) -> Void
    
    /// 填充绘制
    /// - Parameters:
    ///   - ctx:    图形上下文
    ///   - path:   绘制路径
    ///   - style:  填充类型
    ///   - size:   绘制尺寸
    func fill(ctx: CGContext, path: UIBezierPath, style: ShapeStyle?, size: CGSize) -> Void
}

// MARK: ------ 默认实现 ------

/// 形状默认实现
public extension Shape {
    /// 填充绘制
    /// - Parameters:
    ///   - ctx:    图形上下文
    ///   - path:   绘制路径
    ///   - style:  填充类型
    ///   - size:   绘制尺寸
    func fill(ctx: CGContext, path: UIBezierPath, style: ShapeStyle?, size: CGSize) {
        
        guard let style = style else { return }
        
        if let color = style as? UIColor {
            ctx.setFillColor(color.cgColor)
            path.fill()
        } else if let img = style as? UIImage {
            img.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// 边框绘制
    /// - Parameters:
    ///   - ctx:         图形上下文
    ///   - path:        绘制路径
    ///   - strokeStyle: 边框填充类型
    func stroke(ctx: CGContext, path: UIBezierPath, strokeStyle: StrokeStyle?) {
        
        guard let style = strokeStyle, style.isNeed else { return }
        
        path.lineWidth = style.lineWidth
        
        if let color = style.lineStyle as? UIColor {
            ctx.setStrokeColor(color.cgColor)
            path.stroke()
        } else if let img = style.lineStyle as? UIImage {
            ctx.setStrokeColor(UIColor(patternImage: img).cgColor)
            path.stroke()
        }
    }
}


// MARK: ------ StrokeStyle -------
/// 边框配置
public struct StrokeStyle {
    /// 边框宽度
    var lineWidth: CGFloat = 0
    /// 边框类型
    var lineStyle: ShapeStyle? = nil
    
    /// 是否需要绘制边框
    var isNeed: Bool {
        get {lineWidth > 0 && lineStyle != nil}
    }
}

// MARK: ****** Shapes ******
/**
    1. RoundedRectangle 矩形带圆角（所有角大小一样）
    2. RoundedCorners   矩形可单独配置一个或多个角的圆角（设置的圆角大小一样）
    3. Circle           圆形（取 width、height 中的最小值设置圆角）
    4. Capsule          左右圆弧（左右圆角一样 1/2 height）
    5. Plural           多样性的圆角（每个角大小可不一样）
 */
/// 矩形带圆角（所有角）
class RoundedRectangle : Shape {
    
    init(radius: CGFloat, style: StrokeStyle? = nil) {
        self.cornerRadius = radius
        self.strokeStyle = style
    }
    
    /// 边框配置
    var strokeStyle: StrokeStyle?
    /// 圆角大小
    private var cornerRadius: CGFloat
    
    /// 绘制路径
    func path(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
    }
}

/// 矩形可单独配置一个或多个角的圆角
class RoundedCorners : Shape {
    
    init(radius: CGFloat, corners: UIRectCorner, style: StrokeStyle? = nil) {
        self.cornerRadius = radius
        self.corners = corners
        self.strokeStyle = style
    }
    
    /// 边框配置
    var strokeStyle: StrokeStyle?
    /// 圆角大小
    private var cornerRadius: CGFloat
    /// 需要设置圆角的角
    private var corners: UIRectCorner

    /// 绘制路径
    func path(in rect: CGRect) -> UIBezierPath {
        return UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
    }
}

/// 圆形
class Circle : Shape {
    
    init(style: StrokeStyle? = nil) {
        self.strokeStyle = style
    }
    
    /// 边框配置
    var strokeStyle: StrokeStyle?

    func path(in rect: CGRect) -> UIBezierPath {
        let minVal = min(rect.size.width, rect.size.height)
        return UIBezierPath(roundedRect: CGRect(origin: .zero, size: CGSize(width: minVal, height: minVal)), cornerRadius: minVal / 2)
    }
}

/// 左右圆弧
class Capsule : Shape {
    
    init(style: StrokeStyle? = nil) {
        self.strokeStyle = style
    }
    
    /// 边框配置
    var strokeStyle: StrokeStyle?

    func path(in rect: CGRect) -> UIBezierPath {
        let height = rect.size.height
        return UIBezierPath(roundedRect: rect, cornerRadius: height / 2)
    }
}

/// 多样性的圆角
class Plural : Shape {
    
    init(_ radius: UIBezierPath.Radius, style: StrokeStyle? = nil) {
        self.radius = radius
        self.strokeStyle = style
    }
    
    /// 圆角大小
    var radius: UIBezierPath.Radius
    /// 边框配置
    var strokeStyle: StrokeStyle?
    /// 绘制rect
    var pathRect: CGRect = .zero
    
    /// 绘制路径
    func path(in rect: CGRect) -> UIBezierPath {
        pathRect = rect
        guard let bpath = UIBezierPath.path(with: self.radius, in: rect) else { return UIBezierPath(rect: rect) }
        return bpath
    }
}

private extension CGSize {
    /// 判断一个 CGSize 是否存在 NaN
    var isNaN: Bool {
        return self.width.isNaN || self.height.isNaN
    }
    /// 判断一个 CGSize 是否存在 infinite
    var isInf: Bool {
        return self.width.isInfinite || self.height.isInfinite
    }

    /// 判断一个 CGSize 是否为空（宽或高为0）
    var isEmpty: Bool {
        return self.width <= 0 || self.height <= 0
    }
    
    /// 判断一个 CGSize 是否合法（例如不带无穷大的值、不带非法数字）
    var isValidated: Bool {
        return !self.isEmpty && !self.isInf && !self.isNaN
    }
    func min() -> CGFloat {
        Swift.min(self.width, self.height)
    }
}
