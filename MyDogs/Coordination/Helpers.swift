import Foundation
import UIKit

extension UIColor {
    /**
     Initialize a UIColor from a hex value
     */
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    /**
     Initialize a UIColor from a hex string e.g. "FFFFFF"
     */
    convenience init?(hexString: String) {
        var int = UInt32()
        if Scanner(string: hexString).scanHexInt32(&int) {
            self.init(hex: Int(int))
        } else {
            return nil
        }
    }
}


extension UINavigationController {
    func applyRoverStyle() {
        self.navigationBar.barTintColor = Colors._77C045
        self.navigationBar.layer.shadowColor = Colors._77C045.cgColor
        self.navigationBar.layer.shadowRadius = 1
        self.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.navigationBar.layer.shadowOpacity = 1.0
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.titleTextAttributes = FontsAndStyles.navigationBarTextAttributes(component: .title)
    }
}


/**
 Commonly used UIColors
 */
class Colors {
    static let _77C045 = UIColor(hexString: "77C045")!
    static let _DFDFDF = UIColor(hexString: "DFDFDF")!
    static let _555555 = UIColor(hexString: "555555")!
    static let _777777 = UIColor(hexString: "777777")!
    static let _989898 = UIColor(hexString: "989898")!
}


/**
 Commonly used UIFonts and associated methods
 */
class FontsAndStyles {
    enum SFUIDisplayFont: String {
        case
        bold = "SFUIDisplay-Bold",
        thin = "SFUIDisplay-Thin",
        medium = "SFUIDisplay-Medium",
        heavy = "SFUIDisplay-Heavy",
        ultralight = "SFUIDisplay-Ultralight",
        regular = "SFUIDisplay-Regular",
        semibold = "SFUIDisplay-Semibold",
        light = "SFUIDisplay-Light",
        black = "SFUIDisplay-Black"
        
        func font(size: CGFloat) -> UIFont? {
            return UIFont(name: self.rawValue, size: 15)
        }
    }
    

    /**
     Factory method for generating NSAttributedString attributes
     */
    class func attributes(
        color: UIColor,
        font: SFUIDisplayFont,
        size: CGFloat,
        lineHeight: CGFloat,
        lineHeightmultiple: CGFloat,
        lineBreakMode: NSLineBreakMode) -> [NSAttributedStringKey : Any] {
        
        var attributes = [NSAttributedStringKey : Any]()
        
        attributes[NSAttributedStringKey.foregroundColor] = color
        if let font = font.font(size: size) {
            attributes[NSAttributedStringKey.font] = font
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.lineHeightMultiple = lineHeightmultiple
        paragraphStyle.lineBreakMode = lineBreakMode
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        return attributes
    }
    
    enum NavigationBarComponent {
        case title, barButton
    }
    class func navigationBarTextAttributes(component: NavigationBarComponent) -> [NSAttributedStringKey : Any] {
        var attributes = [NSAttributedStringKey : Any]()
        switch component {
        case .title:
            attributes[NSAttributedStringKey.foregroundColor] = UIColor.white
        case .barButton:
            attributes[NSAttributedStringKey.foregroundColor] = UIColor.white.withAlphaComponent(0.8)
        }
        if let font = FontsAndStyles.SFUIDisplayFont.medium.font(size: 16) {
            attributes[NSAttributedStringKey.font] = font
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 26
        paragraphStyle.lineHeightMultiple = 1.6
        attributes[NSAttributedStringKey.paragraphStyle] = paragraphStyle
        return attributes
    }
}
