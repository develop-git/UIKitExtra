//
//  UISegmentedControl+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/7/7.
//



public extension UIKitSetting where Base : UISegmentedControl {
    
    @discardableResult
    func titles(_ title: [String]) -> Self {
        base.removeAllSegments()
        for (i, e) in title.enumerated() {
            base.insertSegment(withTitle: e, at: i, animated: false)
        }
        return self
    }
    
    @discardableResult
    func images(_ imgs: [UIImage?]) -> Self {
        base.removeAllSegments()
        for (i, e) in imgs.enumerated() {
            base.insertSegment(with: e, at: i, animated: false)
        }
        return self
    }
}
