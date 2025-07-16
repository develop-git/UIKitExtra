//
//  UITextField+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//

// MARK: ------- UITextField -------
public extension UIKitSetting where Base : UITextField {
    @discardableResult
    func placeholder(_ text: String?) -> Self {
        self.base.placeholder = text
        return self
    }
    
    @discardableResult
    func textColor(_ color: UIColor?) -> Self {
        self.base.textColor = color
        return self
    }
    
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
    
    @discardableResult
    func textAlign(_ alignment: NSTextAlignment) -> Self {
        self.base.textAlignment = .center
        return self
    }
    
    @discardableResult
    func borderStyle(_ style: UITextField.BorderStyle) -> Self {
        self.base.borderStyle = style
        return self
    }
    
    @discardableResult
    func clearBtnMode(_ mode: UITextField.ViewMode) -> Self {
        self.base.clearButtonMode = mode
        return self
    }
}

#if canImport(QMUIKit) && os(iOS)

public extension UIKitSetting where Base : QMUITextField {
    
    /// 设置placeholder \ color
    /// - Parameters:
    ///   - text: placeholder
    ///   - color: color
    @discardableResult
    func placeholder(_ text: String?, color: UIColor? = nil) -> Self {
        self.base.placeholder = text
        self.base.placeholderColor = color
        return self
    }
    
    /// 设置最大输入长度
    /// - Parameter len: 长度
    @discardableResult
    func maxlen(_ len: UInt) -> Self {
        self.base.maximumTextlen = len
        return self
    }
    
    /// 文字边距
    @discardableResult
    func inset(_ edge: UIEdgeInsets) -> Self {
        self.base.textInsets = edge
        return self
    }
}
#endif

#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UITextField {
    
    /// 绑定text到label上
    @discardableResult
    func textBind(to label: UILabel) -> Self {
        base.rx.text.bind(to: label.rx.text).disposed(by: base.rx.disposeBag)
        return self
    }
    
    /// 绑定text到button上
    @discardableResult
    func textBind(to button: UIButton, for state: UIButton.State = .normal) -> Self {
        base.rx.text.bind(to: button.rx.title(for: state)).disposed(by: base.rx.disposeBag)
        return self
    }
    
    /// text变化
    /// - Parameters:
    ///   - dispose: 销毁
    ///   - action: 执行动作
    @discardableResult
    func textChanged(action: @escaping(_ text: String)->Void) -> Self {
        base.rx.text.orEmpty
            .subscribe { text in
                action(text)
            }
            .disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif
