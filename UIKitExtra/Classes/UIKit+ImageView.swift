//
//  UIImageView+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//



// MARK: ----- UIImageView -----
public extension UIImageView {
    /// imageView init
    /// - Parameters:
    ///   - image: 资源文件名
    @discardableResult
   convenience init(image: String?) {
        self.init(frame: .zero)
        self.image = UIImage(image)
    }
    
    /// imageView init
    /// - Parameters:
    ///   - image: 资源文件名
    @discardableResult
    static func make(from image: String?) -> UIImageView {
        UIImageView(image: image)
    }
}

public extension UIKitSetting where Base : UIImageView {
    #if canImport(Kingfisher)
    /// 通过URL获取图片
    /// - Parameters:
    ///   - url:   图片地址
    @discardableResult
    func imageURL(_ imageURL: String?) -> Self {
        guard let validURL = imageURL?.toURL() else { return self }
        self.base.kf.setImage(with: .network(validURL))
        return self
    }
    #endif
    
    /// 设置本地图片
    /// - Parameters:
    ///   - named: 图片名
    @discardableResult
    func imageName(_ imageName: String) -> Self {
        self.base.image = UIImage(imageName)
        return self
    }
    
    /// 设置图片
    /// - Parameter img: 图片
    @discardableResult
    func image(_ image: UIImage?) -> Self {
        self.base.image = image
        return self
    }
    
    /// 设置图片显示模式
    /// - Parameter img: 图片显示模式
    @discardableResult
    func showMode(_ mode: UIView.ContentMode) -> Self {
        self.base.contentMode = mode
        return self
    }
}
