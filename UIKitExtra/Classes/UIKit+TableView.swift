//
//  UITableView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ----- UITableView -------
public extension UITableView {
    @discardableResult
   convenience init(style: UITableView.Style) {
        self.init(frame: .zero, style: style)
    }
}

public extension UIKitSetting where Base : UITableView {
    
    var zeroHeight: CGFloat {
        if self.base.style == .plain {
            return 0
        }
        return CGFLOAT_MIN
    }
    
    #if os(iOS)
    @discardableResult
    func separator(style: UITableViewCell.SeparatorStyle) -> Self {
        self.base.separatorStyle = style
        return self
    }
    
    @discardableResult
    func separator(color: UIColor) -> Self {
        self.base.separatorColor = color
        return self
    }
    #endif
    
    @discardableResult
    func separator(inset: UIEdgeInsets) -> Self {
        self.base.separatorInset = inset
        return self
    }
    
    
    /// 设置代理、数据源代理
    /// - Parameters:
    ///   - target: 代理对象
    ///   - proxyType: 代理类型
    @discardableResult
    func proxy(_ target: AnyObject?, for proxyType: ListViewProxy = .dataSource) -> Self {
        guard let target = target else { return self }
        if proxyType.contains(.delegate) {
            self.base.delegate = target as? UITableViewDelegate
        }
        if proxyType.contains(.dataSource) {
            self.base.dataSource = target as? UITableViewDataSource
        }
        return self
    }
    
    enum TableSubviewHeightLayoutType {
        case normal, dynamic
    }
    
    enum TableSubviewHeightType {
        case cell(def: CGFloat = 60, _ layout: TableSubviewHeightLayoutType = .normal)
        case header(def: CGFloat = 44, _ layout: TableSubviewHeightLayoutType = .normal)
        case footer(def: CGFloat = 44, _ layout: TableSubviewHeightLayoutType = .normal)
    }
    
    @discardableResult
    func heights(for heightTypes: [TableSubviewHeightType]) -> Self {
        heightTypes.forEach {height(for: $0)}
        return self
    }
    @discardableResult
    func height(for heightType: TableSubviewHeightType) -> Self {
        switch heightType {
        case .cell(let value, let layout):
            switch layout {
            case .normal:
                self.base.rowHeight = value
            case .dynamic:
                self.base.rowHeight = UITableView.automaticDimension
                self.base.estimatedRowHeight = value
            }
        case .header(let value, let layout):
            switch layout {
            case .normal:
                self.base.sectionHeaderHeight = value
            case .dynamic:
                self.base.sectionHeaderHeight = UITableView.automaticDimension
                self.base.estimatedSectionHeaderHeight = value
            }
        case .footer(let value, let layout):
            switch layout {
            case .normal:
                self.base.sectionFooterHeight = value
            case .dynamic:
                self.base.sectionFooterHeight = UITableView.automaticDimension
                self.base.estimatedSectionFooterHeight = value
            }
        }
        return self
    }
    
    @discardableResult
    func hiddenFooter() -> Self {
        self.base.sectionFooterHeight = self.zeroHeight
        self.base.tableFooterView?.isHidden = true
        return self
    }
    
    @discardableResult
    func hiddenHeader() -> Self {
        self.base.sectionHeaderHeight = self.zeroHeight
        self.base.tableHeaderView?.isHidden = true
        return self
    }
}

public extension UIKitSetting where Base : UITableView {
    // MARK: 注册cell
    /// 注册cell 注意此处的cell重用ID为类型字符串
    /// - Parameters:
    ///   - cellClass: cell 类型
    @discardableResult
    func register<T>(_ cellClass: T.Type) -> Self where T : UITableViewCell {
        self.base.register(cellClass, forCellReuseIdentifier: "\(cellClass)")
        return self
    }
    
    // MARK: 注册header\footer
    /// 注册header/footer 注意此处的重用ID为类型字符串
    /// - Parameters:
    ///   - cls: header/footer 类型
    @discardableResult
    func register<T>(_ supplementaryClass: T.Type) -> Self where T : UITableViewHeaderFooterView {
        self.base.register(supplementaryClass, forHeaderFooterViewReuseIdentifier: "\(supplementaryClass)")
        return self
    }
}

public extension UITableView {
    // MARK: 重用cell
    /// 重用cell
    /// - Parameters:
    ///   - cellClass: cell 类型
    @discardableResult
    func  reusable<T>(_ cellClass: T.Type, at indexPath: IndexPath) -> T where T : UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: "\(cellClass)", for: indexPath) as! T
    }
    
    /// 重用header/footer
    @discardableResult
    func reusable<T>(_ supplementaryClass: T.Type) -> T? where T : UITableViewHeaderFooterView {
        return self.dequeueReusableHeaderFooterView(withIdentifier: "\(supplementaryClass)") as? T
    }
}
