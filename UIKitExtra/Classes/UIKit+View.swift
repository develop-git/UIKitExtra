//
//  UIView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ----- UIView ------
#if canImport(RxGesture)
import RxGesture

public extension UIKitSetting where Base : UIView {
    
    /// 为视图添加点击手势
    /// - Parameters:
    ///   - dispose: rx销毁
    ///   - action: 执行动作
    @discardableResult
    func tap(_ action: @escaping(_ view: UIView)->Void) -> Self {
        if base.layer.opacity < 0.1 {
            return self
        }
        base.rx.tapGesture().when(.recognized).subscribe { [weak base = self.base] tap in
            guard let base = base else { return }
            /// val.isCompleted: 当前动作是主动调用还是自动调用(disposeBag销毁时自动调用闭包)
            tap.isCompleted.false { action(base) }
        }.disposed(by: base.rx.disposeBag)
        return self
    }
    
    /// 为视图添加双击手势
    /// - Parameters:
    ///   - dispose: rx销毁
    ///   - action: 执行动作
    @discardableResult
    func doubleTap(_ action: @escaping(_ view: UIView)->Void) -> Self {
        if self.layer.opacity < 0.1 {
            return self
        }
        self.base.rx.tapGesture {gesture, _ in
            gesture.numberOfTapsRequired = 2
        }
        .when(.recognized)
        .subscribe { [weak base = self.base] tap in
            guard let base = base else { return }
            /// val.isCompleted: 当前动作是主动调用还是自动调用(disposeBag销毁时自动调用闭包)
            tap.isCompleted.false { action(base) }
        }.disposed(by: base.rx.disposeBag)
        return self
    }
    
    /// 为视图添加拖动手势
    @discardableResult
    func pan(translate:((_ point: CGPoint, _ view: UIView)->Void)?, ended:((_ point: CGPoint, _ view: UIView)->Void)?) -> Self {
        if self.layer.opacity < 0.1 {
            return self
        }
        let panGesture = self.base.rx.panGesture().share(replay: 1)
        
        panGesture
            .when(.possible, .began, .changed)
            .asTranslation()
            .subscribe(onNext: {[weak base = self.base] translation, _ in
                guard let base = base else { return }
                translate?(translation, base)
            })
            .disposed(by: base.rx.disposeBag)
        
        panGesture
            .when(.ended)
            .asTranslation()
            .subscribe(onNext: {[weak base = self.base] translation, _ in
                guard let base = base else { return }
                ended?(translation, base)
            })
            .disposed(by: base.rx.disposeBag)
       
        return self
    }
    
    /// 为视图添加长按手势
    @discardableResult
    func longPress(began:((_ view: UIView)->Void)?) -> Self {
        if self.layer.opacity < 0.1 {
            return self
        }
        self.base.rx.longPressGesture()
            .when(.began)
            .subscribe(onNext: {[weak base = self.base] _ in
                guard let base = base else { return }
                began?(base)
            })
            .disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif

#if canImport(QMUIKit) && os(iOS)

public extension UIKitSetting where Base : UIView {
    /// 设置角标数字
    @discardableResult
    func badge(_ badge : UInt) -> Self {
        self.base.qmui_badgeInteger = badge
        return self
    }
    
    /// 设置角标字符串
    @discardableResult
    func badge(_ badgeStr: String) -> Self {
        self.base.qmui_badgeString = badgeStr
        return self
    }
    
    /// 设置角标偏移
    @discardableResult
    func badgeOffset(_ offset : CGPoint, isLandscape: Bool = false) -> Self {
        isLandscape ? (self.base.qmui_badgeOffsetLandscape = offset) : (self.base.qmui_badgeOffset = offset)
        return self
    }
    
    /// 添加磨砂视觉效果
    @discardableResult
    func addBlueEffect(radius: CGFloat, configure:((_ view: UIView, _ effect: UIVisualEffectView)->Void)? = nil) -> Self {
        let effect = UIKitSetting.effectView(with: radius)
        self.base.addSubview(effect)
        configure?(self.base, effect)
        return self
    }
    
    @discardableResult
    static func effectView(with radius: CGFloat) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect.blurEffect(with: radius))
    }
}

public extension UIKitSetting where Base : UIVisualEffectView {
    @discardableResult
    func effect(radius: CGFloat) -> Self {
        self.base.effect = UIBlurEffect.blurEffect(with: radius)
        return self
    }
    
    @discardableResult
    func removeEffect() -> Self {
        self.base.effect = nil
        return self
    }
    
    @discardableResult
    func forground(_ color: UIColor) -> Self {
        self.base.qmui_foregroundColor = color
        return self
    }
}

public extension UIBlurEffect {
    static func blurEffect(with radius: CGFloat) -> UIBlurEffect {
        return self.qmui_effect(withBlurRadius: radius)
    }
}
#endif

// MARK: 视图初始化
public extension UIView {
    
    /// 创建一个静态size视图
    /// - Parameters:
    ///   - size: 视图尺寸
    /// Note: 最终生效的尺寸取决于最后设置尺寸
    convenience init(size: CGFloat) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: size, height: size)))
    }
    
    /// 创建一个已知width、height的视图
    /// - Parameters:
    ///   - width:  宽度配置
    ///   - height: 高度配置
    /// Note: 最终生效的尺寸取决于最后设置尺寸
    convenience init(width: CGFloat, height: CGFloat) {
        self.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
    }
}

// MARK: 添加视图、设置视图背景颜色、圆角、阴影、手势，视图size
public extension Array where Element : UIView {
    @discardableResult
    func add(to view: UIView?) -> Self {
        guard let view = view else { return self }
        self.forEach {view.addSubview($0)}
        return self
    }
}

public extension UIKitSetting where Base == Array<UIView> {
    /// 设置视图背景颜色
    /// - Parameters:
    ///   - color: 颜色值
    @discardableResult
    func background(_ color: ()->(UIColor)) -> Self {
        self.base.forEach { $0.set.background(color()) }
        return self
    }
}

public extension UIView {
    /// 将多个目标视图添加本视图上
    /// - Parameters:
    ///   - views: 目标视图集合
    @discardableResult
    func addSubviews(_ views: UIView...) -> Self {
        views.forEach {
            self.addSubview($0)
        }
        return self
    }
    
    /// 将视图添加到目标视图上
    /// - Parameters:
    ///   - view: 目标视图
    @discardableResult
    func add(to view: UIView) -> Self {
        view.addSubview(self)
        return self
    }
}

public extension UIKitSetting where Base : UIView {
    
    /// 设置视图按角度旋转
    @discardableResult
    func rotateAngle(_ angle: CGFloat) -> Self {
        self.base.transform = CGAffineTransform(rotationAngle: .pi * angle / 180.0)
        return self
    }
    
    /// 设置视图tint color颜色
    /// - Parameters:
    ///   - color: 颜色值
    @discardableResult
    func tintColor(_ color: UIColor?) -> Self {
        self.base.tintColor = color ?? .black
        return self
    }
    
    /// 设置视图背景颜色
    /// - Parameters:
    ///   - color: 颜色值
    @discardableResult
    func background(_ color: UIColor) -> Self {
        self.base.backgroundColor = color
        return self
    }
    
    /// 设置视图背景颜色 圆角， 不进行裁剪操作
    /// - Parameters:
    ///   - color: 颜色值
    ///   - radius: 圆角大小
    ///   - clips: 是否进行裁剪
    @discardableResult
    func background(_ color: UIColor, radius: CGFloat, clips: Bool = false) -> Self {
        self.base.backgroundColor = color
        if radius > 0 {
            self.cornerRadius(radius, clips: clips)
        }
        return self
    }
    
    /// 设置视图背景颜色 圆角
    /// - Parameters:
    ///   - color: 颜色值
    ///   - radius: 圆角大小
    ///   - corners: 需要设置圆角的角
    ///   - clips: 是否进行裁剪
    @discardableResult
    func background(_ color: UIColor, radius: CGFloat, for corners: UIRectCorner , clips: Bool = false) -> Self {
        self.base.backgroundColor = color
        if radius > 0 {
            self.cornerRadius(radius, for: corners, clips: clips)
        }
        return self
    }
    
    /// 设置圆角
    /// - Parameters:
    ///   - radius: 圆角大小
    ///   - corners: 需要设置的角
    ///   - clips: 是否进行裁剪 默认 false
    @discardableResult
    func cornerRadius(_ radius: CGFloat, for corners: UIRectCorner = .allCorners, clips: Bool = false) -> Self {
        let layer = self.base.layer
        layer.cornerRadius = radius
        if #available(iOS 13.0, tvOS 13.0, *) {
            layer.cornerCurve = .continuous
        }
        if #available(iOS 11.0, tvOS 11.0, *) {
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        }
        if clips { self.base.clipsToBounds = true }
        return self
    }
    
    /// 设置边框
    /// - Parameters:
    ///   - width: 边框宽度
    ///   - color: 边框颜色
    @discardableResult
    func border(color: UIColor, width: CGFloat) -> Self {
        self.base.layer.borderWidth = width
        self.base.layer.borderColor = color.cgColor
        return self
    }
    
    /// 设置阴影
    /// - Parameters:
    ///   - color: 阴影颜色
    ///   - radius: 阴影宽度值
    ///   - offset: 阴影偏移
    ///   - opacity: 透明度
    ///   - path: 阴影路径
    @discardableResult
    func shadow(color: UIColor, radius: CGFloat = 3, offset: CGSize = CGSize(width: 3, height: 3), opacity: Float = 1, path: CGPath? = nil) -> Self {
        let layer = self.base.layer
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = path
        return self
    }

    /// 移除所有子视图
    /// - Parameters:
    ///   - views: 目标视图集合
    @discardableResult
    func removeSubviews() -> Self {
        self.base.subviews.forEach {
            $0.removeFromSuperview()
        }
        return self
    }
    
    /// 视图是否可见
    @discardableResult
    func visible(_ visible: Bool) -> Self {
        self.base.isHidden = !visible
        return self
    }
    
    @discardableResult
    func priority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) -> Self {
        base.setContentHuggingPriority(priority, for: axis)
        base.setContentCompressionResistancePriority(priority, for: axis)
        return self
    }
}

// MARK: 设置渐变背景颜色 线性渐变、圆形渐变、圆锥渐变
public extension UIKitSetting where Base : UIView {
    
    /// 线性渐变
    /// 若要实现相应的效果，视图子类还需实现:
    /// public override class var layerClass: AnyClass {
    ///     return CAGradientLayer.self
    /// }
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - startPoint: 起始点 eg1: .top/UnitPoint.top,
    ///                       eg2: CGPoint(x: 0.3, y: 1.0)
    ///   - endPoint:   结束点 eg1: .top/UnitPoint.top,
    ///                       eg2: CGPoint(x: 0.3, y: 1.0)
    ///   - locations: 颜色位置数组，数值单调递增 eg: [0.0, 0.3]
    @discardableResult
    func linearGradient<StartPoint, EndPoint>(colors: [UIColor]?, start startPoint: StartPoint, end endPoint: EndPoint, locations: [NSNumber]? = nil) -> Self where StartPoint: GradientPoint, EndPoint: GradientPoint {
        self.gradient(colors: colors, startPoint: startPoint, endPoint: endPoint, locations: locations)
    }
    
    /// 圆形渐变
    /// 若要实现相应的效果，视图子类还需实现:
    /// public override class var layerClass: AnyClass {
    ///     return CAGradientLayer.self
    /// }
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - endPoint: 结束点 eg1: .bottomTrailing/UnitPoint.bottomTrailing,
    ///                     eg2: CGPoint(x: 1.0, y: 1.0)
    ///   - locations: 颜色位置数组，数值单调递增 eg: [0.0, 0.3]
    @discardableResult
    func radialGradient<EndPoint>(colors: [UIColor]?, end endPoint: EndPoint, locations: [NSNumber]? = nil) -> Self where EndPoint : GradientPoint {
        self.gradient(colors: colors, startPoint: .center, endPoint: endPoint, locations: locations, for: .radial)
    }
    
    /// 圆锥形渐变
    /// 若要实现相应的效果，视图子类还需实现:
    /// public override class var layerClass: AnyClass {
    ///     return CAGradientLayer.self
    /// }
    /// - Parameters:
    ///   - colors: 颜色数组
    ///   - endPoint: 结束点 eg1: .bottomTrailing/UnitPoint.bottomTrailing,
    ///                     eg2: CGPoint(x: 1.0, y: 1.0)
    ///   - locations: 颜色位置数组，数值单调递增 eg: [0.0, 0.3]
    @discardableResult
    @available(iOS 12.0, tvOS 12.0, *)
    func conicGradient<EndPoint>(colors: [UIColor]?, end endPoint: EndPoint, locations: [NSNumber]? = nil) -> Self where EndPoint : GradientPoint {
        self.gradient(colors: colors, startPoint: .center, endPoint: endPoint, locations: locations, for: .conic)
    }
    
    /// 渐变
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - startPoint: 起始点
    ///   - endPoint: 结束点
    ///   - locations: 颜色位置数组，数组内容单调递增
    ///   - type: `axial' (the default value), `radial', and `conic'
    @discardableResult
    func gradient<StartPoint, EndPoint>(colors: [UIColor]?, startPoint: StartPoint, endPoint: EndPoint, locations: [NSNumber]? = nil, for type: CAGradientLayerType = .axial) -> Self where StartPoint : GradientPoint, EndPoint : GradientPoint {
        if let gradientLayer = self.base.layer as? CAGradientLayer {
            gradientLayer.type = type
            gradientLayer.colors = colors?.compactMap { $0.cgColor }
            gradientLayer.startPoint = startPoint.startPoint
            gradientLayer.endPoint = endPoint.endPoint
            gradientLayer.locations = locations
        }
        return self
    }
}

// MARK: 动画
public extension UIView {
    @discardableResult
    static func animator(time: TimeInterval, curve: UIView.AnimationCurve = .easeInOut, animations:(()->Void)?) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(duration: time, curve: curve, animations: animations)
    }
}

public extension UIView {
    var size: CGSize {
        get { self.bounds.size }
        set {}
    }
    
    /// 返回类名相同的视图
    /// - Parameters:
    ///   - className: 类名
    func subviews(of className: String) -> [UIView]? {
        return self.subviews.filter { String(describing: type(of: $0)) == className }
    }
}
