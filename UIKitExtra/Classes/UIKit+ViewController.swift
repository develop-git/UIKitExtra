//
//  UIViewController+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//

// MARK: ----- UIViewController -----
// MARK: QMUI子类控制器导航栏控制方法(隐藏、手势、背景图片、状态栏设置等)
/**
 配置导航栏相关的系统方法(qmui)
 /// 导航栏是否隐藏
 override func preferredNavigationBarHidden() -> Bool {
     return true
 }
 /// 强制开启返回手势(导航栏隐藏以后系统返回手势失效)
 override func forceEnableInteractivePopGestureRecognizer() -> Bool {
     true
 }
 /// 是否由qmui接管系统手势(实现此方法后，无需在willAppe\wilDisapper方法中设置导航栏是否隐藏)
 override func shouldCustomizeNavigationBarTransitionIfHideable() -> Bool {
     true
 }
 /// 设置导航栏背景图片
 override func qmui_navigationBarBackgroundImage() -> UIImage? {
     return nil
 }
 /// 状态栏设置
 override var preferredStatusBarStyle: UIStatusBarStyle {
     return .default
 }
 */
#if os(iOS) || os(tvOS)
public extension UIViewController {
    
    func isPresented() -> Bool {
        let vc = self
        if let root = UIApplication.shared.rootViewController, root != vc {
            return false
        }
        let result = vc.presentingViewController?.presentedViewController == vc
        return result
    }
    
    func push(to vc: UIViewController?, animated: Bool = true) {
        guard let vc = vc else { return }
        #if canImport(QMUIKit) && os(iOS)
        navigationController?.qmui_pushViewController(vc, animated: animated)
        #else
        navigationController?.pushViewController(vc, animated: animated)
        #endif
    }
    
    func pop(to vc: UIViewController?, animated: Bool = true) {
        guard let vc = vc else { return }
        #if canImport(QMUIKit) && os(iOS)
        navigationController?.qmui_pop(to: vc, animated: animated)
        #else
        navigationController?.popToViewController(vc, animated: animated)
        #endif
    }
    
    func pop(to vc: UIViewController.Type, animated: Bool = true) {
        
        #if canImport(QMUIKit) && os(iOS)
        if let controller = navigationController?.viewControllers.first(where: { $0.isKind(of: vc) }) {
            navigationController?.qmui_pop(to: controller, animated: animated)
        }
        #else
        if let controller = navigationController?.viewControllers.first(where: { $0.isKind(of: vc) }) {
            navigationController?.popToViewController(controller, animated: animated)
        }
        #endif
        
    }
    
    func pop(toRoot rootFlag: Bool = false, animated: Bool = true) {
        #if canImport(QMUIKit) && os(iOS)
        if rootFlag {
            navigationController?.qmui_popToRootViewController(animated: animated)
        } else {
            navigationController?.qmui_popViewController(animated: animated)
        }
        #else
        if rootFlag {
            navigationController?.popToRootViewController(animated: animated)
        } else {
            navigationController?.popViewController(animated: animated)
        }
        #endif
    }
}

public extension UIKitSetting where Base : UIViewController {
#if os(iOS)
    /// 是否开启返回手势识别
    /// - Parameters:
    ///   - enable: 是否开启
    @discardableResult
    func enablePopGesture(_ enable: Bool) -> Self {
        self.base.navigationController?.interactivePopGestureRecognizer?.isEnabled = enable
        return self
    }
#endif
    
    /// 忽略安全区域
    /// - Parameters:
    ///   - rect: 需要忽略的方向
    @discardableResult
    func ignorSafeArea(_ rect: UIRectEdge) -> Self {
        self.base.edgesForExtendedLayout = rect
        return self
    }
    
    /// 忽略安全区域
    /// - Parameters:
    ///   - ignore: 是否忽略安全区域
    @discardableResult
    func ignorSafeArea(_ ignore: Bool) -> Self {
        self.base.edgesForExtendedLayout = ignore ? .all : UIRectEdge(rawValue: 0)
        return self
    }
    
#if os(iOS)
    /// 是否开启大标题显示
    @discardableResult
    @available(iOS 11.0, *)
    func enableLargeTitle(_ enable: Bool = true) -> Self {
        self.base.navigationController?.navigationBar.prefersLargeTitles = enable
        self.base.navigationController?.navigationItem.largeTitleDisplayMode = enable ? .always : .never
        return self
    }
    
    #if canImport(QMUIKit)
    @discardableResult
    @available(iOS 11.0, *)
    func disableOtherLargeTitle() -> Self {
        let cur = UIWindow.rootController()?.qmui_visibleViewControllerIfExist()
        guard let cur = cur else { return self }
        if !cur.isKind(of: type(of: self.base)) {
            enableLargeTitle(false)
        }
        return self
    }
    #endif
#endif
}

public extension UIKitSetting where Base : UIViewController {
    
    enum ControllerShowType {
    case push, present, other
    }
    var showType: ControllerShowType {
        if self.base.navigationController?.viewControllers.count ?? 0 > 1 {
            return .push
        }
        if self.base.presentingViewController != nil {
            return .present
        }
        return .other
    }
    
    /// 是否隐藏导航栏
    @discardableResult
    func navbarHide(_ hidden: Bool, animated: Bool = true) -> Self {
        self.base.navigationController?.setNavigationBarHidden(hidden, animated: animated)
        return self
    }
    
#if os(iOS)
    /// 设置导航栏item
    @discardableResult
    func navbarBackItem(_ navigationBackItem: UIBarButtonItem) -> Self {
        self.base.navigationItem.backBarButtonItem = navigationBackItem
        return self
    }
#endif
    
    /// navigation bar item 位置
    enum BarItemPosition {
    case left, right
    }
    
    /// 设置导航栏item
    @discardableResult
    func navbarItem(_ navigationItem: UIBarButtonItem, for position: BarItemPosition = .right) -> Self {

        switch position {
        case .left:
            self.base.navigationItem.leftBarButtonItem = navigationItem
        case .right:
            self.base.navigationItem.rightBarButtonItem = navigationItem
        }
        return self
    }
    
    /// 设置导航栏items
    @discardableResult
    func navbarItems(_ navigationItems: [UIBarButtonItem], for position: BarItemPosition = .right) -> Self {
        switch position {
        case .left:
            self.base.navigationItem.leftBarButtonItems = navigationItems
        case .right:
            self.base.navigationItem.rightBarButtonItems = navigationItems
        }
        return self
    }
    
    /// 设置导航栏title view
    @discardableResult
    func titleView(_ titleView: UIView?, frame: CGRect? = nil) -> Self {
    
        let width = UIScreen.main.bounds.size.width
        titleView?.frame = frame ?? CGRect(x: 0, y: 0, width: width, height: 26)
        self.base.navigationItem.titleView = titleView
        return self
    }
}
#endif

