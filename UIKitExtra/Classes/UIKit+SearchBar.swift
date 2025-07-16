//
//  UISearchBar+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/5/31.
//


#if os(iOS) || os(tvOS)
#if canImport(RxSwift) && canImport(NSObject_Rx)
import RxSwift

public extension UIKitSetting where Base : UISearchBar {
    @discardableResult
    func editing(action:@escaping()->Void) -> Self {
        base.rx.textDidBeginEditing.asObservable().subscribe { _ in
            action()
        }.disposed(by: base.rx.disposeBag)
        return self
    }
    
    @discardableResult
    func endEditing(action:@escaping()->Void) -> Self {
        base.rx.textDidEndEditing.asObservable().subscribe { _ in
            action()
        }.disposed(by: base.rx.disposeBag)
        return self
    }
    
    @discardableResult
    func cancelBtnAction(action:@escaping()->Void) -> Self {
        base.rx.cancelButtonClicked.asObservable().subscribe { _ in
            action()
        }.disposed(by: base.rx.disposeBag)
        return self
    }
    
    @discardableResult
    func searchBtnAction(action:@escaping()->Void) -> Self {
        base.rx.searchButtonClicked.asObservable().subscribe { _ in
            action()
        }.disposed(by: base.rx.disposeBag)
        return self
    }
}
#endif
#endif
