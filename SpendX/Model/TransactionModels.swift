import UIKit

// MARK: - Transaction domain models (helper folder)
// Used by the table view, custom cell, and header.

struct Transaction: Hashable, Identifiable {
    let id: UUID
    let date: Date
    let name: String
    let category: String
    let accountName: String
    let amount: Double      // positive number; use isOutgoing to add sign in UI
    let isOutgoing: Bool    // true = expense (-), false = income (+)
    let logoColor: UIColor  // color for 30x30 logo circle
    
    init(id: UUID = UUID(), date: Date, name: String, category: String, accountName: String, amount: Double, isOutgoing: Bool, logoColor: UIColor) {
        self.id = id
        self.date = date
        self.name = name
        self.category = category
        self.accountName = accountName
        self.amount = amount
        self.isOutgoing = isOutgoing
        self.logoColor = logoColor
    }
}

struct DateSection: Hashable {
    let date: Date
    let total: Double        // sum for this date (income positive, expense negative)
    let transactions: [Transaction]
}
