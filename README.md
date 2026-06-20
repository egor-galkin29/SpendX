# SpendX 💸

SpendX is an iOS expense tracking app built with UIKit and Swift. The goal of the app is to give users a simple and clean way to track their personal spending, see where their money goes, and view totals in their preferred currency.

---

## 🎯 Purpose

The long-term vision for SpendX is a full personal finance tool where users can:
- Track both income and expenses across multiple accounts
- Filter transactions by time period (week, month, year)
- View spending breakdowns by category with visual charts
- Support multiple currencies with live exchange rates
- Set budgets and get notified when limits are exceeded

---

## ✅ Current Functionality

The app is currently in early development. What works right now:

- **Add a new expense** — tap the + button to open a popup where you enter an amount, a category name, and pick a color for the category
- **Save expenses** — transactions are saved to the device using UserDefaults, so data persists between app sessions
- **Currency filter** — the currency button in the top filter bar lets you switch between major world currencies (USD, EUR, GBP, JPY, etc.), and the total amount label recalculates and displays in the selected currency automatically
- **Total amount label** — shows the sum of all saved expenses converted to the currently selected currency

---

## 🏗️ Project Structure (MVVM)

The project follows the **MVVM** (Model — View — ViewModel) architecture pattern. Here's what that means in simple terms:

Think of it as three layers, each with one job:

| Layer | Job | Files in this project |
|---|---|---|
| **Model** | Defines what the data looks like | `Models.swift` |
| **ViewModel** | Handles all the logic (saving, loading, calculating) | `TransactionViewModel.swift` |
| **View / ViewController** | Only handles what the user sees on screen | `MainViewController.swift`, `SpendingsPopupViewController.swift` |

The idea is that the ViewController never touches the data directly — it always goes through the ViewModel. This keeps the code clean, easier to read, and easier to fix when something breaks.

---

## 📁 File Breakdown

```
SpendX/
├── Model/
│   └── Models.swift                  — The BetaTransaction struct: defines what a transaction looks like (id, category, amount, color, etc.)
│
├── ViewModel/
│   └── TransactionViewModel.swift    — All logic: saving to UserDefaults, loading, currency conversion, calculating total amount
│
├── VC/
│   ├── MainViewController.swift      — The main screen: shows total, donut chart, category list, and filter buttons
│   ├── SpendingsPopupViewController  — The "New Expense" popup: text fields, color picker, save button
│   └── MainViewCells/
│       ├── ButtonsGroups.swift       — Factory that creates the three filter buttons (February, Currency, Spendings)
│       └── CategoryCollectionViewCell.swift — The individual category cards shown at the bottom of the main screen
│
├── Helper/
│   ├── AppDelegate.swift             — Standard iOS app entry point
│   ├── SceneDelegate.swift           — Manages the app window and scene lifecycle
│   ├── Extensions.swift              — Reusable helper extensions used across the project
│   └── LaunchScreen                  — The screen shown while the app is loading
│
└── Fonts/                            — Custom fonts used in the app UI
```

---

## 🛠️ Built With

- Swift
- UIKit (programmatic UI, no Storyboard)
- UserDefaults (local data persistence)
- MVVM architecture
