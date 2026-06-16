import UIKit
import Foundation
// File for additional extensions to not repeat the code

//MARK: Public fonts methods
enum FontBook {
    static func medium(size: CGFloat) -> UIFont { UIFont(name: "IBMPlexSans-Medium", size: size) ?? .systemFont(ofSize: size, weight: .medium)}
    
    static func bold(size: CGFloat) -> UIFont { UIFont(name: "IBMPlexSans-Bold", size: size) ?? .systemFont(ofSize: size, weight: .bold)}
    
    static func regular(size: CGFloat) -> UIFont { UIFont(name: "IBMPlexSans-Regular", size: size) ?? .systemFont(ofSize: size, weight: .regular)}
    
    static func semiBold(size: CGFloat) -> UIFont { UIFont(name: "IBMPlexSans-SemiBold", size: size) ?? .systemFont(ofSize: size, weight: .semibold)}
}

//MARK: Creates text

enum AttributedTextBuilder {
    static func make(_ text: String, font: UIFont, color: UIColor, kern: Int) ->NSAttributedString {
        let attributed = NSMutableAttributedString(string: text)
        
        attributed.addAttributes([
            .font: font,
            .kern: kern,
            .foregroundColor: color
        ], range: NSRange(location: 0, length: (text as NSString).length))
        return attributed
    }
}

//MARK: DataFormater

enum DateFormatters {
    static let dayTitle: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMM d, yyyy"
        return df
    }()
}

//MARK: Extension to UILable for letter spacing

extension UILabel {
    func setText(
        _ text: String,
        font: UIFont,
        letterSpacingPrecent: CGFloat
    ) {
        let kern = font.pointSize * (letterSpacingPrecent / 100)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .kern: kern
        ]
        
        self.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
