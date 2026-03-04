import UIKit

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
