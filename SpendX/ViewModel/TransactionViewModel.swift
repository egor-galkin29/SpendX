import UIKit


//MARK: ViewModel (class which connects Models with Viewcontrollers

final class TransactionViewModel {
    
    // Property for the transaction structur e(see folder Model)
    private var transactions: [BetaTransaction] = []
    
    // Calculates ttal for all expences with chosen currency
    var totalAmount: Double {
        let rawValue = transactions.reduce(0) { $0 + $1.amount}
        return rawValue * selectedCurrency.2
    }
    
    // Saves the chosen currency to the memory
    var selectedCurrency: (String, String, Double) = ("USD", "$", 1.0) {
        didSet {
            UserDefaults.standard.setValue(selectedCurrency.0, forKey: "selectedCurrency")
        }
    }
    
    // Loads chosen curreny from memory
    func loadCurrency() {
        
        //checks if exists and sets the property for data
        guard let saved = UserDefaults.standard.string(forKey: "selectedCurrency"),
              let found = currencies.first(where: { $0.0 == saved })
        else { return }
        
        selectedCurrency = found
    }
    
    // Saves the transaction model (see folder Model) to the memory
    func save(_ transaction: BetaTransaction) {
        transactions.append(transaction)
        if let encode = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.setValue(encode, forKey: "transactions")
        }
    }
    
    // Loads chosen transaction from memory
    func load(){
        
        //checks if exists and sets the property for datz
        guard let data = UserDefaults.standard.data(forKey: "transactions"),
              let decoded = try? JSONDecoder().decode([BetaTransaction].self, from: data) else { return }
        
        transactions = decoded
    }
}
