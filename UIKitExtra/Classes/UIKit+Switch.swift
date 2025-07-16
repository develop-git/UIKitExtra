//
//  UISwitch+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/5/22.
//


#if os(iOS)
#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UIKitSetting where Base : UISwitch {
    @discardableResult
    func valueChanged(action: @escaping(_ isOn: Bool)->Void) -> Self {
        base.rx.value.subscribe { value in
            action(value)
        }.disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif
#endif

