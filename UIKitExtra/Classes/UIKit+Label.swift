//
//  UILabel+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//


// MARK: ----- Label -----
// MARK: label初始化
#if os(iOS) || os(tvOS)
public extension UILabel {
    
    /// 初始化
    @discardableResult
   convenience init(text: String) {
        self.init(frame: .zero)
        self.text = text
    }
    
    /// 初始化
    @discardableResult
   convenience init(attribute: NSAttributedString) {
        self.init(frame: .zero)
        self.attributedText = attribute
    }
}

// MARK: 设置label内容、字体、颜色、行数、对齐等
public extension UIKitSetting where Base : UILabel {
    /// 设置label字体
    /// - Parameters:
    ///   - font: 字体
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        self.base.font = font ?? .system(14)
        return self
    }
    
    @discardableResult
    func font(_ fontSize: CGFloat) -> Self {
        self.base.font = .system(fontSize)
        return self
    }
    
    /// 设置label内容行数
    /// - Parameter num: 行数
    @discardableResult
    func lines(_ lines: Int) -> Self {
        self.base.numberOfLines = lines
        return self
    }
    
    /// 开启换行功能
    /// - Parameter num: 行数
    @discardableResult
    func enableWrap() -> Self {
        self.base.numberOfLines = 0
        return self
    }
    
    /// 设置label文字
    /// - Parameters:
    ///   - text: 文字内容
    @discardableResult
    func text(_ text: String?, color: UIColor = .black, align: NSTextAlignment = .left) -> Self {
        self.base.text = text
        self.base.textAlignment = align
        self.base.textColor = color
        return self
    }
    
    /// 设置label富文本
    @discardableResult
    func attributeText(_ attributeText: NSAttributedString?) -> Self {
        self.base.attributedText = attributeText
        return self
    }
    
    /// 设置label文字颜色
    /// - Parameters:
    ///   - color: 颜色值 default .black
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        self.base.textColor = color ?? .black
        return self
    }
    
    /// 设置label文字对齐方式
    /// - Parameters:
    ///   - align: 对齐方式 default .center
    @discardableResult
    func textAlign(_ align: NSTextAlignment = .center) -> Self {
        self.base.textAlignment = align
        return self
    }
    
    /// 设置label文字截断方式
    /// - Parameters:
    ///   - mode: 截断方式 default .center
    @discardableResult
    func lineBreakMode(_ mode: NSLineBreakMode) -> Self {
        self.base.lineBreakMode = mode
        return self
    }
}
#endif

#if canImport(QMUIKit) && os(iOS)
@available(iOS 11.0, *)
public extension UIKitSetting where Base : QMUILabel {
    
    /// 开启跑马灯效果
    @discardableResult
    func enableMarquee() -> Self {
        self.base.qmui_startNativeMarquee()
        return self
    }
    
    /// 关闭跑马灯效果
    @discardableResult
    func stopMarquee() -> Self {
        self.base.qmui_stopNativeMarquee()
        return self
    }
    
    /// 是否正运行跑马灯效果
    @discardableResult
    func isRunningMarquee() -> Bool {
        return self.base.qmui_nativeMarqueeRunning
    }
}

public extension UIKitSetting where Base : QMUILabel {
    /// 内容边距
    @discardableResult
    func inset(_ edge: UIEdgeInsets) -> Self {
        self.base.contentEdgeInsets = edge
        return self
    }
    
    /// 开启长按复制功能
    /// - Parameters:
    ///   - menu: 复制功能按钮标题
    @discardableResult
    func enableCopy(menu: String? = nil) -> Self {
        self.base.canPerformCopyAction = true
        self.base.menuItemTitleForCopyAction = menu
        return self
    }
    
    /// 复制操作
    @discardableResult
    func copyAction(action: @escaping(_ lab: Label, _ str: String)->Void) -> Self {
        self.base.didCopyBlock = { lab, str in
            action(lab, str)
        };
        return self
    }
}

public typealias MarqueeLabel = QMUIMarqueeLabel
public extension UIKitSetting where Base : MarqueeLabel {
    
    /// 控制滚动的速度，1 表示一帧滚动 1pt，10 表示一帧滚动 10pt，默认为 .5，与系统一致。
    @discardableResult
    func speed(_ speed: CGFloat) -> Self {
        self.base.speed = speed
        return self
    }
    
    /// 当文字第一次显示在界面上，以及重复滚动到开头时都要停顿一下，这个属性控制停顿的时长，默认为 2.5（也是与系统一致），单位为秒。
    @discardableResult
    func pauseDuration(_ interval: TimeInterval) -> Self {
        self.base.pauseDurationWhenMoveToEdge = interval
        return self
    }

    /// 用于控制首尾连接的文字之间的间距，默认为 40pt。
    @discardableResult
    func space(_ space: CGFloat) -> Self {
        self.base.spacingBetweenHeadToTail = space
        return self
    }

    /// 用于控制左和右边两端的渐变区域的百分比，默认为 0.2，则是 20% 宽。
    @discardableResult
    func fade(_ fade: CGFloat) -> Self {
        self.base.fadeWidthPercent = fade
        return self
    }
}

#endif
