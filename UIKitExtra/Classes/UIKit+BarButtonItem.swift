//
//  UIBarButtonItem+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//


// MARK: ----- UIBarButtonItem ------
public extension UIBarButtonItem {
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - item: BarButtonItem 类型
    @discardableResult
    convenience init(system: UIBarButtonItem.SystemItem) {
        self.init(barButtonSystemItem: system, target: nil, action: nil)
    }
    
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - image: BarButtonItem 图片
    @discardableResult
    convenience init(image: UIImage?) {
        self.init(image: image, style: .plain, target: nil, action: nil)
    }
    
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - title: BarButtonItem 标题
    @discardableResult
    convenience init(title: String?) {
        self.init(title: title, style: .plain, target: nil, action: nil)
    }
    
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - item: BarButtonItem 类型
    @discardableResult
    static func systemItem(_ systemItem: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
    }
    
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - title: BarButtonItem 标题
    @discardableResult
    static func titleItem(_ title: String?) -> UIBarButtonItem {
        UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
    }
    
    /// 初始化系统 BarButtonItem
    /// - Parameters:
    ///   - image: BarButtonItem 图片
    @discardableResult
    static func imageItem(_ image: UIImage?) -> UIBarButtonItem {
        UIBarButtonItem(image: image, style: .plain, target: nil, action: nil)
    }
}

#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UIKitSetting where Base : UIBarButtonItem {
    /// UIBarButtonItem 点击手势
    /// - Parameters:
    ///   - dispose: 销毁
    ///   - action: 执行动作
    
    @discardableResult
    func tap(action: @escaping()->Void) -> Self {
        self.base.rx.tap.subscribe { val in
            /// val.isCompleted: 当前动作是主动调用还是自动调用(disposeBag销毁时自动调用闭包)
            val.isCompleted.false {
                action()
            }
        }.disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif
