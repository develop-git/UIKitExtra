//
//  AppCollectionView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//

import Foundation
import UIKit

public extension String {

    enum CollectionKindType {
        case header, footer
    }
    
    static func kindTypeString(for type: CollectionKindType) -> String {
        return type == .header ? UICollectionView.elementKindSectionHeader : UICollectionView.elementKindSectionFooter
    }
    
    func isKindType(of type: CollectionKindType) -> Bool {
        if type == .header, self == UICollectionView.elementKindSectionHeader {
            return true
        }
        if type == .footer, self == UICollectionView.elementKindSectionFooter {
            return true
        }
        return false
    }
}

public extension UIKitSetting where Base : UICollectionViewFlowLayout {
    
    private var flowLayoutDelegate: UICollectionViewDelegateFlowLayout? {
        get {self.base.collectionView?.delegate as? UICollectionViewDelegateFlowLayout}
    }
    private var collection: UICollectionView {
        get {self.base.collectionView!}
    }
    
    /// 设置items间距
    /// - Parameters:
    ///   - vert: 垂直间距
    ///   - horz: 水平间距
    @discardableResult
    func itemsSpaces(row: CGFloat, col: CGFloat) -> Self {
        self.base.minimumLineSpacing = row
        self.base.minimumInteritemSpacing = col
        return self
    }
    
    /// 设置item动态高度
    @discardableResult
    func dynamicSize(default size: CGSize = CGSize(width: UIScreen.main.bounds.size.width, height: 60)) -> Self {
        self.base.estimatedItemSize = size
        return self
    }
    
    @discardableResult
    func itemSize(_ size: CGSize) -> Self {
        self.base.itemSize = size
        return self
    }
    
    /// 设置分组边距
    @discardableResult
    func insets(_ insets: UIEdgeInsets) -> Self {
        self.base.sectionInset = insets
        return self
    }
    
    enum FlowLayoutMethodsType {
        case itemSize
        case sectionInset
        case rowSpace
        case columSpace
        case sectionHeaderSize
        case sectionFooterSize
    }
    
    func responds(to methodType: FlowLayoutMethodsType) -> Bool {
        guard let delegate = flowLayoutDelegate else { return false }
        switch methodType {
        case .itemSize:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:sizeForItemAt:)))
        case .sectionInset:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:)))
        case .rowSpace:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumLineSpacingForSectionAt:)))
        case .columSpace:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:)))
        case .sectionHeaderSize:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForHeaderInSection:)))
        case .sectionFooterSize:
            return delegate.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:referenceSizeForFooterInSection:)))
        }
    }
    
    func itemSize(at indexPath: IndexPath) -> CGSize {
        guard self.responds(to: .itemSize) else {
            return self.base.itemSize
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, sizeForItemAt: indexPath)
    }
    
#if os(iOS)
    func sectionInset(at section: Int) -> UIEdgeInsets {
        guard self.responds(to: .sectionInset) else {
            let insets = self.base.sectionInset
            return UIEdgeInsets(top: insets.top, left: insets.left, bottom: insets.bottom, right: insets.right)
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, insetForSectionAt: section)
    }
#endif

    func rowSpace(at section: Int) -> CGFloat {
        guard self.responds(to: .rowSpace) else {
            return self.base.minimumLineSpacing
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, minimumLineSpacingForSectionAt: section)
    }

    func columSpace(at section: Int) -> CGFloat {
        guard self.responds(to: .columSpace) else {
            return self.base.minimumInteritemSpacing
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, minimumInteritemSpacingForSectionAt: section)
    }

    func headerSize(at section: Int) -> CGSize {
        guard self.responds(to: .sectionHeaderSize) else {
            return self.base.headerReferenceSize
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, referenceSizeForHeaderInSection: section)
    }
    
    func footerSize(at section: Int) -> CGSize {
        guard self.responds(to: .sectionFooterSize) else {
            return self.base.footerReferenceSize
        }
        return flowLayoutDelegate!.collectionView!(collection, layout: self.base, referenceSizeForFooterInSection: section)
    }
}

public extension UICollectionView {
    
    /// 初始化 流布局 collection view
    /// - Parameter config: layout 配置 closure
    @discardableResult
   convenience init(configure: ((_ layout: UICollectionViewFlowLayout)->Void)?) {
        let flow = UICollectionViewFlowLayout()
        if let configure = configure {
            configure(flow)
        }
        self.init(frame: .zero, collectionViewLayout: flow)
    }
    
    /// 初始化 collection view
    /// - Parameters:
    ///   - type: layout布局类型
    ///   - config: layout, collection view 配置闭包
    @discardableResult
   convenience init<T>(layout: T.Type, configure: ((_ layout: T)->Void)?) where T : UICollectionViewFlowLayout {
        let layoutIns = layout.init()
        if let configure = configure {
            configure(layoutIns)
        }
        self.init(frame: .zero, collectionViewLayout: layoutIns)
    }
    
    /// 内容尺寸
    var ctxSize: CGSize {
        get {self.contentSize}
    }
    /// ctx剩余可利用的宽度
    var remainWidth: CGFloat {
        get {
            let layoutSize = self.collectionViewLayout.collectionViewContentSize
            return layoutSize != .zero ? layoutSize.width : (ctxSize.width - contentInset.left - contentInset.right)
        }
    }
    
    /// 计算section item 的宽度
    func itemWidth(column: Int, colSpace: CGFloat) -> CGFloat {
        return gridItemWidth(column: column, space: colSpace, superWidth: self.remainWidth)
    }
    
    /// 返回 计算出的 grid 布局视图 width
    /// - Parameters:
    ///   - config: 计算配置
    private func gridItemWidth(column: Int, space: CGFloat, superWidth: CGFloat) -> CGFloat {
        if column < 2 {return superWidth}
        return ((superWidth - (space * CGFloat(column - 1))) / CGFloat(column))
    }
}

public extension UIKitSetting where Base : UICollectionView {
    
    enum UICollectionViewReusableSupplementary {
        case header, footer
        
        var kind: String {
            switch self {
            case .header:
                return UICollectionView.elementKindSectionHeader
            case .footer:
                return UICollectionView.elementKindSectionFooter
            }
        }
    }
    
    // MARK: 注册cell\header\footer
    /// 注册Cell
    @discardableResult
    func register<T>(_ cellClass: T.Type) -> Self where T : UICollectionViewCell {
        self.base.register(cellClass, forCellWithReuseIdentifier: "\(cellClass)")
        return self
    }
    /// 注册Header/Footer
    @discardableResult
    func register<T>(_ supplementaryClass: T.Type, for registerType: UICollectionViewReusableSupplementary) -> Self where T : UICollectionReusableView {
        self.base.register(supplementaryClass, forSupplementaryViewOfKind: registerType.kind, withReuseIdentifier: "\(supplementaryClass)")
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
            self.base.delegate = target as? UICollectionViewDelegate
        }
        if proxyType.contains(.dataSource) {
            self.base.dataSource = target as? UICollectionViewDataSource
        }
        return self
    }
}

public extension UICollectionView {
    // MARK: 重用cell\header\footer
    /// 重用Cell
    @discardableResult
    func reusable<T>(_ cellClass: T.Type, at indexPath: IndexPath) -> T where T : UICollectionViewCell {
        return self.dequeueReusableCell(withReuseIdentifier: "\(cellClass)", for: indexPath) as! T
    }
    
    /// 重用Header/Footer
    @discardableResult
    func reusable<T>(_ supplementaryClass: T.Type, at indexPath: IndexPath, kind supplementaryKind: String) -> T where T : UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(ofKind: supplementaryKind, withReuseIdentifier: "\(supplementaryKind)", for: indexPath) as! T
    }
}
