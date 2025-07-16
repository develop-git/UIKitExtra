//
//  UIControl+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/7/6.
//

import Foundation

#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UIKitSetting where Base : UIControl {
    /// button点击手势
    /// - Parameters:
    ///   - dispose: rx销毁
    ///   - action: 执行动作
    @discardableResult
    func controlAction(_ event: UIControl.Event, action: @escaping(_ ctr: Self)->Void) -> Self {
        self.base.rx.controlEvent(event).subscribe {[weak base = self.base] val in
            guard let base = base else { return }
            /// val.isCompleted: 当前动作是主动调用还是自动调用(disposeBag销毁时自动调用闭包)
            val.isCompleted.false { action(base) }
        }
        .disposed(by: base.rx.disposeBag)
        return self
    }
}

public extension UIKitSetting where Base : UISegmentedControl {
    
    @discardableResult
    /// UISegmentedControl  点击手势
    func tapEvent(_ action: @escaping(_ index: Int, _ control: UISegmentedControl)->Void) -> Self {
        return controlAction(.valueChanged) { ctr in
            guard let ctr = ctr as? UISegmentedControl else { return }
            action(ctr.selectedSegmentIndex, ctr)
        }
    }
}

public extension UIKitSetting where Base : UIButton {
    
    /// button手势
    @discardableResult
    func addEvent(_ event: UIControl.Event, action: @escaping(_ btn: UIButton)->Void) -> Self {
        return controlAction(event) { ctr in
            action(ctr as! UIButton)
        }
    }
    
    /// button点击手势
    @discardableResult
    func tapEvent(_ action: @escaping(_ btn: UIButton)->Void) -> Self {
        return addEvent(.touchUpInside, action: action)
    }
}
#endif
