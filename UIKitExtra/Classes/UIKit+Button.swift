//
//  UIButton+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//


// MARK: button初始化
public extension UIButton {
    /// 初始化button
    /// - Parameters:
    ///   - title: 标题
    ///   - image: 图片
    @discardableResult
    convenience init(title: String?, image: String?) {
        self.init(type: .custom)
        self.set.title(title).titleColor(.blue).image(image)
    }
    
    /// 初始化button
    /// - Parameters:
    ///   - title: 标题
    @discardableResult
    convenience init(title: String) {
        self.init(type: .custom)
        self.set.title(title).titleColor(.blue)
    }
    
    /// 初始化button
    /// - Parameters:
    ///   - image: 图片
    @discardableResult
    convenience init(image: String) {
        self.init(type: .custom)
        self.set.titleColor(.blue).image(image)
    }
    
    /// 初始化button
    /// - Parameters:
    ///   - image: 图片
    @discardableResult
    convenience init(image: UIImage?) {
        self.init(type: .custom)
        self.set.image(image)
    }
    
    /// 创建button
    /// - Parameters:
    ///   - title: 标题
    ///   - image: 图片
    @discardableResult
    static func make(title: String? = nil, image: String? = nil) -> UIButton {
        UIButton(title: title, image: image)
    }
}

#if canImport(Kingfisher)
import Kingfisher
public extension UIKitSetting where Base : UIButton {
    /// 通过URL获取图片
    /// - Parameters:
    ///   - url:   图片地址
    @discardableResult
    func image(url: String?, for state: UIControl.State = .normal) -> Self {
        guard let validURL = url?.toURL() else { return self }
        self.base.kf.setImage(with: .network(validURL), for: .normal)
        return self
    }
}
#endif

// MARK: 设置button内容、图片、字体大小、文字对齐、文字颜色等
public extension UIKitSetting where Base : UIButton {
    /// 设置button字体
    /// - Parameters:
    ///   - font: 字体
    @discardableResult
    func font(_ font: UIFont?) -> Self {
        self.base.titleLabel?.font = font ?? .system(14)
        return self
    }
    
    @discardableResult
    func font(_ fontSize: CGFloat) -> Self {
        self.base.titleLabel?.font = .system(fontSize)
        return self
    }
    
    /// 设置button标题
    /// - Parameters:
    ///   - title: title
    ///   - state: 状态
    @discardableResult
    func title(_ title: String?, for state: UIControl.State = .normal) -> Self {
        self.base.setTitle(title, for: state)
        return self
    }
    
    /// 设置button图片
    /// - Parameters:
    ///   - name:  图片名称
    ///   - state: 状态
    @discardableResult
    func image(_ imgName: String?, for state: UIControl.State = .normal) -> Self {
        self.base.setImage(UIImage(imgName), for: state)
        return self
    }
    
    /// 设置button图片
    /// - Parameters:
    ///   - name:  图片名称
    ///   - state: 状态
    @discardableResult
    func image(_ image: UIImage?, for state: UIControl.State = .normal) -> Self {
        self.base.setImage(image, for: state)
        return self
    }
    
    /// 设置button标题颜色
    /// - Parameters:
    ///   - color: 颜色
    @discardableResult
    func titleColor(_ color: UIColor?, for state: UIControl.State = .normal) -> Self {
        self.base.setTitleColor(color, for: state)
        return self
    }
    
    /// 设置button标题对齐方式
    /// - Parameters:
    ///   - align: 对齐方式 default .center
    @discardableResult
    func titleAlign(_ align: NSTextAlignment?) -> Self {
        self.base.titleLabel?.textAlignment = align ?? .center
        return self
    }
    
    /// 设置内容边距
    @discardableResult
    func inset(_ edge: UIEdgeInsets) -> Self {
        self.base.contentEdgeInsets = edge
        return self
    }
    
    @discardableResult
    func enable(_ enable: Bool = true) -> Self {
        self.base.isEnabled = enable
        return self
    }
    
#if canImport(QMUIKit) && os(iOS)
    @discardableResult
    func imageTintColor(_ color: UIColor?, for state: UIButton.State = .normal) -> Self {
        base.qmui_setImageTintColor(color, for: state)
        return self
    }
#endif
}

#if canImport(QMUIKit) && os(iOS)
import QMUIKit.QMUIButton

public extension UIKitSetting where Base : QMUIButton {
    
    /// 设置图片位置
    @discardableResult
    func imagePosition(_ position: QMUIButtonImagePosition) -> Self {
        self.base.imagePosition = position
        return self
    }
    
    /// 设置图片与文字之间的间隔
    @discardableResult
    func space(_ space: CGFloat) -> Self {
        self.base.spacingBetweenImageAndTitle = space
        return self
    }
    
    enum ButtonInsetsType {
    case content, title, image
    }
    /// 设置图片与文字之间的间隔
    @discardableResult
    func inset(_ edge: UIEdgeInsets, for type: ButtonInsetsType = .content) -> Self {
        switch type {
        case .content:
            self.base.contentEdgeInsets = edge
        case .title:
            self.base.imageEdgeInsets = edge
        case .image:
            self.base.titleEdgeInsets = edge
        }
        return self
    }
}
#endif
