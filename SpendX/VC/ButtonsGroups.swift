
import UIKit

//MARK: Factories
/*
 This file creates structures, which helps prevent repetiveness of creating simmilar buttons.
 Each stracture used for different stack of buttons, though i must ackmowledge that only FilterButtons are usable in my app.
 Every other factory is for visual appearance of the buttons, which i will work in the future.
 */


struct PeriodButtons {
    let week: UIButton
    let month: UIButton
    let year: UIButton
    
    init() {
        self.week = PeriodButtons.makeUIButtonPeriod("Week")
        self.month = PeriodButtons.makeUIButtonPeriod("Month")
        self.year = PeriodButtons.makeUIButtonPeriod("Year")
    }
    
    var all: [UIButton] { [week, month, year] }
    
    private static func makeUIButtonPeriod(_ title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .clear
        config.baseForegroundColor = .black
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20)
        
        let ns = AttributedTextBuilder.make(title,
                                            font: FontBook.medium(size: 14),
                                            color: .black,
                                            kern: 0)
        let swiftAttr = AttributedString(ns)
        config.attributedTitle = swiftAttr
        
        let button = UIButton(configuration: config)
        return button
    }
}

//MARK: Filter buttons Factory (only one used)
struct FilterButtons {
    let calendar: UIButton
    let currency: UIButton
    let type: UIButton
    
    init() {
        self.calendar = FilterButtons.makeUIButtonFilter("February")
        self.currency = FilterButtons.makeUIButtonFilter("Currency")
        self.type = FilterButtons.makeUIButtonFilter("Spendings")
    }
    
    // List containing all buttons; helps add all of them together to the stack
    var all: [UIButton] { [calendar, currency, type] }
    
    // Function which sets up buttons
    private static func makeUIButtonFilter(_ title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        let ns = AttributedTextBuilder.make(title,
                                            font: FontBook.semiBold(size: 14),
                                            color: .white,
                                            kern: Int(-0.3))
        let swiftAttr = AttributedString(ns)
        
        config.attributedTitle = swiftAttr
        
        //configurations of the button: BG, FG
        config.baseBackgroundColor = .lightBlue
        config.baseForegroundColor = .white
        
        // Paddings in the buttons 
        config.contentInsets = NSDirectionalEdgeInsets(top: 3.5,
                                                       leading: 13,
                                                       bottom: 3.5,
                                                       trailing: 13)
        //Creating and placing the small triangle
        config.image = UIImage(named: "polygon_1")
        config.imagePlacement = .trailing
        config.imagePadding = 10
        
        //changing corner radius
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 13
        button.clipsToBounds = true
        
        return button
    }
}
