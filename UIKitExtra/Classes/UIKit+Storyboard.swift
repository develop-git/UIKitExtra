//
//  UIStoryboard+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



public extension UIStoryboard {
    convenience init(name: String) {
        self.init(name: name, bundle: Bundle.main)
    }
    
    func controller(with identifier: String) -> UIViewController? {
        self.instantiateViewController(withIdentifier: identifier)
    }
}
