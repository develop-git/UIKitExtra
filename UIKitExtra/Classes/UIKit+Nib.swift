//
//  UINib+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ----- UINib -------
public extension UINib {
    convenience init(name: String) {
        self.init(nibName: name, bundle: nil)
    }
    convenience init(cls: AnyClass) {
        self.init(nibName: String(describing: type(of: cls)), bundle: nil)
    }
    static func make(with className: String) -> UINib {
        UINib(nibName: className, bundle: nil)
    }
    
    static func lunchScreen(for name: String = "LaunchScreen") -> UIView? {
        let screen = Bundle.main.loadNibNamed(name, owner: self)?.first
        return screen as? UIView
    }
}
