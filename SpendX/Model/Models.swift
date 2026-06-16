import UIKit

// MARK: Models for everything
// Will be separated or expended to the new files when becomes too big

// Main Model for the transaction
//MARK: currently not used due to complexity
struct Transaction: Hashable, Identifiable {
    let id: UUID
    let date: Date
    let name: String
    let category: String
    let accountName: String
    let amount: Double      // positive number; use isOutgoing to add sign in UI
    let logoColor: String  // color for 30x30 logo circle
    
    init(id: UUID = UUID(), date: Date, name: String, category: String, accountName: String, amount: Double, logoColor: String) {
        self.id = id
        self.date = date
        self.name = name
        self.category = category
        self.accountName = accountName
        self.amount = amount
        self.logoColor = logoColor
    }
}

// Model for the date, which will be implemented to sort transaction by time
//MARK: not used
struct DateSection: Hashable {
    let date: Date
    let total: Double        // sum for this date (income positive, expense negative)
    let transactions: [Transaction]
}

// Bets Model for transaction
//MARK: is used in this project right now
struct BetaTransaction: Hashable, Codable {
    
    let category: String
    let amount: Double      // positive number; use isOutgoing to add sign in UI
    let logoColor: String  // color for 30x30 logo circle
    
    init(category: String, amount: Double, logoColor: String) {
        self.category = category
        self.amount = amount
        self.logoColor = logoColor
    }
}

// Model for the currencies
public let currencies: [(String, String, Double)] = [
    ("USD", "$", 1.0),
    ("EUR", "€", 0.89),
    ("GBP", "£", 0.77),
    ("JPY", "¥", 144.5),
    ("RUB", "₽", 72.4),
    ("CNY", "¥", 6.76),
    ("INR", "₹", 95.1),
    ("CAD", "$", 1.38),
    ("AUD", "$", 1.42)
]
