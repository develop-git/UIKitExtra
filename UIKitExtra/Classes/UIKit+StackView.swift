//
//  UIStackView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/7/12.
//



public extension UIKitSetting where Base : UIStackView {
    
    @discardableResult
    func addSubview(_ view: UIView) -> Self {
        base.addArrangedSubview(view)
        return self
    }
    
    @discardableResult
    func addSubviews(_ views: UIView...) -> Self {
        views.forEach {
            base.addArrangedSubview($0)
        }
        return self
    }
    
    @discardableResult
    func removeSubview(_ view: UIView) -> Self {
        base.removeArrangedSubview(view)
        return self
    }

    @discardableResult
    func insertSubview(_ view: UIView, at stackIndex: Int) -> Self {
        base.insertArrangedSubview(view, at: stackIndex)
        return self
    }

    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
        base.axis = axis
        return self
    }

    @discardableResult
    func distribution(_ distribution: UIStackView.Distribution) -> Self {
        base.distribution = distribution
        return self
    }
   
    @discardableResult
    func alignment(_ alignment: UIStackView.Alignment) -> Self {
        base.alignment = alignment
        return self
    }
    
    @discardableResult
    func spacing(_ spacing: CGFloat) -> Self {
        base.spacing = spacing
        return self
    }
}
