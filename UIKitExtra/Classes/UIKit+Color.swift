//
//  UIColor+Exts.swift
//  Foundation+Extra
//
//  Created by jian on 2023/4/21.
//

public extension UIColor {
    static let designKit = DesignKitPalette.self

    enum DesignKitPalette {
        public static let primary: UIColor = dynamicColor(light: UIColor(hex: 0x0770e3), dark: UIColor(hex: 0x6d9feb))
        public static let background: UIColor = dynamicColor(light: .white, dark: .black)
        public static let secondaryBackground: UIColor = dynamicColor(light: UIColor(hex: 0xf1f2f8), dark: UIColor(hex: 0x1D1B20))
        public static let tertiaryBackground: UIColor = dynamicColor(light: .white, dark: UIColor(hex: 0x2C2C2E))
        public static let line: UIColor = dynamicColor(light: UIColor(hex: 0xcdcdd7), dark: UIColor(hex: 0x48484A))
        public static let primaryText: UIColor = dynamicColor(light: UIColor(hex: 0x111236), dark: .white)
        public static let secondaryText: UIColor = dynamicColor(light: UIColor(hex: 0x68697f), dark: UIColor(hex: 0x8E8E93))
        public static let tertiaryText: UIColor = dynamicColor(light: UIColor(hex: 0x8f90a0), dark: UIColor(hex: 0x8E8E93))
        public static let quaternaryText: UIColor = dynamicColor(light: UIColor(hex: 0xb2b2bf), dark: UIColor(hex: 0x8E8E93))

        static private func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
            if #available(iOS 13.0, *) {
                return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
            } else {
                return light
            }
        }
    }
}

public extension UIColor {
    convenience init(hex: Int) {
        let components = (
                R: CGFloat((hex >> 16) & 0xff) / 255,
                G: CGFloat((hex >> 08) & 0xff) / 255,
                B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}


// MARK: ----- UIColor ------
public extension UIColor {
    /// 使用rgb生成颜色
    /// - Parameters:
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        let divisor = CGFloat(255)
        self.init(red: r / divisor, green: g / divisor, blue: b / divisor, alpha: alpha)
    }
    
    /// 使用rgb生成颜色
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
        let divisor = CGFloat(255)
        self.init(red: red / divisor, green: green / divisor, blue: blue / divisor, alpha: alpha)
    }
    
    /// hex颜色，支持：RGB、ARGB、RRGGBB、AARRGGBB
    convenience init(hex: String?) {
        guard let hex = Self.removeHexPrefix(hex), hex.count.in(1...8) else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
            return
        }
        let rgba = Self.hexRGBA(with: hex)
        self.init(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    /// hex颜色，支持：RGB、ARGB、RRGGBB、AARRGGBB
    @discardableResult
    static func hex(with hexString: String?) -> UIColor {
        guard let hex = removeHexPrefix(hexString), hex.count.in(1...8) else {
            return .clear
        }
        let rgba = hexRGBA(with: hex)
        return UIColor(red: rgba.r, green: rgba.g, blue: rgba.b, alpha: rgba.a)
    }
    
    /// 使用rgba生成颜色
    @discardableResult
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        UIColor(r: r, g: g, b: b, alpha: alpha)
    }
    
    /// 使用rgba生成颜色
    @discardableResult
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) -> UIColor {
        UIColor(r: red, g: green, b: blue, alpha: alpha)
    }
    
    /// 生成随机颜色
    static var random: UIColor {
       return UIColor(.random(in:0...255), .random(in:0...255), .random(in:0...255))
    }
}


public extension UIColor {
    
    /// 使用图片生成颜色
    /// - Parameter image: 图片源
    static func imageColor(_ image: UIImage?) -> UIColor {
        guard let image = image else {return UIColor(r: 0, g: 0, b: 0)}
        return UIColor(patternImage: image)
    }
    
    /// 添加透明度
    /// - Parameter opacity: 透明度
    @discardableResult
    func opacity(_ opacity: CGFloat) -> UIColor {
        self.withAlphaComponent(opacity)
    }
    
    /// 透明渐变转换
    /// - Parameters:
    ///   - color: 目标颜色
    ///   - opacity: 当前透明度
    @discardableResult
    func change(to color: UIColor, opacity: CGFloat) -> UIColor {
        let opacity =  Swift.min(opacity, 1.0)
        let fromComp = self.compnent()
        let toComp = color.compnent()
        let finalR = fromComp.red + (toComp.red - fromComp.red) * opacity
        let finalG = fromComp.green + (toComp.green - fromComp.green) * opacity
        let finalB = fromComp.blue + (toComp.blue - fromComp.blue) * opacity
        let finalA = fromComp.alpha + (toComp.alpha - fromComp.alpha) * opacity
        return UIColor(r: finalR, g: finalG, b: finalB, alpha: finalA)
    }
}

fileprivate extension UIColor {
    /// 颜色组成
    struct ColorCompnent {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha = 1.0
    }
    func compnent() -> ColorCompnent {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return ColorCompnent(red: red * 255, green: green * 255, blue: blue * 255, alpha: alpha)
        }
        return ColorCompnent()
    }
    
    /// hex颜色值转 rgb颜色值
    static func hexColorScanner(hex: String, start: Int, len: Int) -> CGFloat {
        guard let substring = hex.substring(from: start, len: len) else { return 0 }
        let fullHex = len == 2 ? substring : "\(substring)\(substring)"
        var value: UInt64 = 0
        guard Scanner(string: fullHex).scanHexInt64(&value) else {
            return 0
        }
        return CGFloat(value) / 255.0
    }
    
    /// hex颜色移除 0x, #, ##
    static func removeHexPrefix(_ hexStr: String?) -> String? {
        guard let hexStr = hexStr, hexStr.count > 0 else { return nil }
        var hex = hexStr
        if hex.hasPrefix("0x") {
            hex = hex.replacingOccurrences(of: "0x", with: "")
        }
        if hex.hasPrefix("#") {
            hex = hex.replacingOccurrences(of: "#", with: "")
        }
        if hex.hasPrefix("##") {
            hex = hex.replacingOccurrences(of: "##", with: "")
        }
        hex = hex.uppercased().replacingOccurrences(of: " ", with: "")
        return hex.count > 0 ? hex : nil
    }
    
    /// hex颜色转 RGBA值
    static func hexRGBA(with hex: String) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        
        var alpha: CGFloat = 1.0, red: CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0
        switch hex.count {
        case 3: // #RGB
            red = hexColorScanner(hex: hex, start: 0, len: 1)
            green = hexColorScanner(hex: hex, start: 1, len: 1)
            blue = hexColorScanner(hex: hex, start: 2, len: 1)
        case 4: // #ARGB
            alpha = hexColorScanner(hex: hex, start: 0, len: 1)
            red = hexColorScanner(hex: hex, start: 1, len: 1)
            green = hexColorScanner(hex: hex, start: 2, len: 1)
            blue = hexColorScanner(hex: hex, start: 3, len: 1)
        case 6: // #RRGGBB
            alpha = 1.0
            red = hexColorScanner(hex: hex, start: 0, len: 2)
            green = hexColorScanner(hex: hex, start: 2, len: 2)
            blue = hexColorScanner(hex: hex, start: 4, len: 2)
        case 8: // #AARRGGBB
            alpha = hexColorScanner(hex: hex, start: 0, len: 2)
            red = hexColorScanner(hex: hex, start: 2, len: 2)
            green = hexColorScanner(hex: hex, start: 4, len: 2)
            blue = hexColorScanner(hex: hex, start: 6, len: 2)
        default:
            break
        }
        return (red, green, blue, alpha)
    }
}

private extension String {
    
    func isSafe(at index: Int) -> Bool {
        if self.isEmpty {
            return false
        }
        if (0...count).contains(index) {
            return true
        }
        return false
    }

    @discardableResult
    func substring(from start: Int, len: Int) -> String? {
        guard self.isSafe(at: start), self.isSafe(at: start + len) else {return nil}
        return (self as NSString).substring(with: NSRange(location: start, length: len))
    }
}

private extension Int {
    /// 是否在区间内
    /// - Parameters:
    ///   - equal: 该值是否可与最大/最小值相等
    @discardableResult
    func `in`(_ range: ClosedRange<Int>, equal: Bool = true) -> Bool {
        if equal {
            return range.lowerBound <= self && self <= range.upperBound
        }
        return range.lowerBound < self && self < range.upperBound
    }
}
