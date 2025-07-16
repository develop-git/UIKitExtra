//
//  UIScrollView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ---- UIScrollView -----
public extension UIKitSetting where Base : UIScrollView {
    #if os(iOS)
    /// 是否开启分页功能
    /// - Parameters:
    ///   - enable: 是否开启
    @discardableResult
    func enablePage(_ enable: Bool) -> Self {
        self.base.isPagingEnabled = enable
        return self
    }
    #endif
    
    @discardableResult
    @available(iOS 11.0, tvOS 11.0, *)
    func adjustBehavior(_ behavior: UIScrollView.ContentInsetAdjustmentBehavior) -> Self {
        self.base.contentInsetAdjustmentBehavior = behavior
        return self
    }
    
    /// 是否隐藏显示器
    /// - Parameter config: 指示器配置选项
    @discardableResult
    func indicatorHide(_ hidden: Bool) -> Self {
        self.base.showsVerticalScrollIndicator = !hidden
        self.base.showsHorizontalScrollIndicator = !hidden
        return self
    }
}

#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UIKitSetting where Base : UIScrollView {
    
    /// scrollView 滑动偏移量
    /// - Parameters:
    ///   - dispose: rx销毁
    ///   - action: 执行动作
    @discardableResult
    func contentOffset(action: @escaping(_ offset: CGPoint)->Void) -> Self {
        self.base.rx.contentOffset
            .subscribe { offset in
                action(offset)
            }.disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif
