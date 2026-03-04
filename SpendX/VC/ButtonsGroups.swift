import UIKit

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
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: "IBMPlexSans-Medium", size: 14)
        attributedTitle.foregroundColor = .black
        config.attributedTitle = attributedTitle
        
        let button = UIButton(configuration: config)
        return button
    }
}


struct SpendAddButtons {
    let add: UIButton
    let spend: UIButton
    
    init() {
        self.add = SpendAddButtons.makeUIButtonSpendAdd(imageName: "plus")
        self.spend = SpendAddButtons.makeUIButtonSpendAdd(imageName: "minus")
    }
    
    var all: [UIButton] { [add, spend] }
    
    private static func makeUIButtonSpendAdd(imageName: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        config.baseBackgroundColor = .lightLightGrey
        config.baseForegroundColor = .black
        
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold)
        config.image = UIImage(systemName: imageName, withConfiguration:  imageConfig)
        
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        
        return button
    }
}

struct FilterButtons {
    let calendar: UIButton
    let currency: UIButton
    let type: UIButton
    
    init() {
        self.calendar = FilterButtons.makeUIButtonFilter("February")
        self.currency = FilterButtons.makeUIButtonFilter("Currency")
        self.type = FilterButtons.makeUIButtonFilter("Spendings")
    }
    
    var all: [UIButton] { [calendar, currency, type] }
    
    private static func makeUIButtonFilter(_ title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        
        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: "IBMPlexSans-SemiBold", size: 14)
        attributedTitle.foregroundColor = .white
        
        config.attributedTitle = attributedTitle
        
        //configurations of the button: BG, FG
        config.baseBackgroundColor = .lightBlue
        config.baseForegroundColor = .white
        
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
