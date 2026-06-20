import UIKit

//MARK: Main class (holds all visual modals)

final class MainViewController: UIViewController {
    
    //MARK: Private Properties
    
    // Attribute for the circle
    private var segments: [(value: CGFloat, color: UIColor)] = []
    
    // Buttons created in the factory (see file ButtonsGroups)
    private let periodButtons = PeriodButtons()
    private let filterButtons = FilterButtons()
    
    // File which connects backend with frontend of app (see foulder ViewModel
    private var viewModel = TransactionViewModel()

    //MARK: UIView (visual models)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.attributedText = AttributedTextBuilder.make("Account name", font: FontBook.bold(size: 24), color: .black, kern: -1)
        return label
    }()
    
    // Stak hold multiple similar buttons which were created in the factory (ButtonsGroups file)
    private lazy var filterStackView: UIStackView = {
        //adds a hidden list which appears when button is pressed
        filterButtons.currency.menu = UIMenu(children: currencies.map { name, sign, rate in
            UIAction(title: "\(sign) \(name) - \(rate)") { [weak self] _ in
                self?.viewModel.selectedCurrency = (name, sign, rate)
                self?.updateAmount()
            }
        })
        filterButtons.currency.showsMenuAsPrimaryAction = true
        
        filterButtons.type.menu = UIMenu(children: [])
        filterButtons.type.showsMenuAsPrimaryAction = true
        
        let stack = UIStackView(arrangedSubviews: filterButtons.all)
        stack.axis = .horizontal
        stack.spacing = 14
        stack.alignment = .center
        
        return stack
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        
        //AttributedTextBuilder is a custom extension for label, which helps set up text (see file Extentions)
        
        label.attributedText = AttributedTextBuilder.make("0 $", font: FontBook.semiBold(size: 32), color: .black, kern: -1)
        return label
    }()
    
    private let addExpenceButton: UIButton = {
       let button = UIButton()
        
        //config is like a font for the text, helps change the size of the system images
        
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "plus", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightLightGrey
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        
        //adds action to the button; uses special type of function (a.k.a selector)
        
        button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let spendingsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("Spendings", font: FontBook.regular(size: 14), color: .black, kern: Int(-0.5))
        return label
    }()
    
    /* chartView
     adds a view for the circle graph
     
     Currently circle isn't working as intented, because i don't know how to work with it.
     It was added (with the help of AI) as only visual (only for now) part to be able to work on everythig else
     */
    
    private let chartView = UIView()
    
    // contains "week", "month", "year" buttons, which were created through factory again
    private lazy var periodStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: periodButtons.all)
        
        stack.backgroundColor = .lightLightGrey
        stack.layer.cornerRadius = 13
        stack.clipsToBounds = true
        stack.distribution = .fillEqually
        return stack
    }()
    
    /* CollectionView
     Was added on my own time, before the final project was annaunced.
     Would be just a visual part due to the fact that it takes substential time and effort for me to work with it.
     */
    private lazy var categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        //layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 15
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reusableID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    //MARK: Override Methods
    
    // This function activates as soon as the app opens up; in general, starts all the application
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // loads the transactions data from the phone's memory
        viewModel.load()
        viewModel.loadCurrency()
        
        // Updates the AmountLabel text
        updateAmount()
        
        // Circle attribute
        segments = [
            (70, .skyBlue),
            (19, .brightPurple),
            (11, .brightGreen)
        ]
        
        // Adds all UI elements to the screen, sets their possitions, etc.
        setupView()
    }
    
    // Something for the circle (again, don't know how it works due to use of Ai)
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        if chartView.layer.sublayers?.isEmpty ?? true {
            createDonutChart(segments: segments, size: 192)
        }
    }
    
    //MARK: Private Methods
    
    private func setupView() {
        
        // Adds view to the screen
        [titleLabel, filterStackView, amountLabel, addExpenceButton, spendingsLabel, chartView, periodStackView, categoryCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        // Sets up the possiton for each element of the screen
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            
            filterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 25),
            
            addExpenceButton.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor),
            addExpenceButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addExpenceButton.heightAnchor.constraint(equalToConstant: 40),
            addExpenceButton.widthAnchor.constraint(equalToConstant: 40),
            
            spendingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            spendingsLabel.topAnchor.constraint(equalTo: amountLabel.bottomAnchor),
            
            chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            chartView.topAnchor.constraint(equalTo: spendingsLabel.bottomAnchor),
            chartView.widthAnchor.constraint(equalToConstant: 192),
            chartView.heightAnchor.constraint(equalToConstant: 192),
            
            periodStackView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 25),
            periodStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            periodStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryCollectionView.topAnchor.constraint(equalTo: periodStackView.bottomAnchor, constant: 25),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 105)
            //categoryCollectionView.bottomAnchor.constraint(equalTo: spendingCollectionView)
        ])
    }
    
    //creates a circlegraph
    private func createDonutChart(segments: [(value: CGFloat, color: UIColor)], size: CGFloat) {
        let total = segments.reduce(0) { $0 + $1.value }
        guard total > 0 else { return }
        
        let outerRadius = size / 2
        let innerRadius = outerRadius * 0.7597
        let thickness = outerRadius - innerRadius
        let radius = innerRadius + thickness / 2
        
        let centerPoint = CGPoint(x: chartView.bounds.midX, y: chartView.bounds.midY)
        
        var startAngle = -CGFloat.pi / 2
        
        var capLayers: [CAShapeLayer] = []
        
        for segment in segments {
            let percentage = segment.value / total
            let endAngle = startAngle + 2 * CGFloat.pi * percentage
            
            let path = UIBezierPath(arcCenter: centerPoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
            
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.strokeColor = segment.color.cgColor
            layer.fillColor = UIColor.clear.cgColor
            layer.lineWidth = thickness
            layer.lineCap = .butt
            
            chartView.layer.addSublayer(layer)
            
            // next code rounds the ends of each segment (add little circles at the end of each segment)
            let endPoint = CGPoint(x: centerPoint.x + radius * cos(endAngle),
                                   y: centerPoint.y + radius * sin(endAngle))
            
            let capPath = UIBezierPath(arcCenter: endPoint, radius: thickness/2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
            
            let capLayer = CAShapeLayer()
            capLayer.path = capPath.cgPath
            capLayer.fillColor = segment.color.cgColor
            
            capLayers.append(capLayer)
            
            startAngle = endAngle
        }
        
        for cap in capLayers {
            chartView.layer.addSublayer(cap)
        }
    }
    
    // Updates the Amount label text on the screen
    private func updateAmount() {
        amountLabel.text = String(format: "%.2f", viewModel.totalAmount) + " \(viewModel.selectedCurrency.1)"
    }
    
    // Button function: opens another window (the one where user add new transaction)
    @objc func addButtonTapped() {
        let popup = SpendingsPopupViewController()
        popup.transactionViewModel = viewModel
        popup.delegate = self
        popup.modalPresentationStyle = .overFullScreen
        popup.modalTransitionStyle = .crossDissolve
        present(popup, animated: true)
    }
}

// extension for the delegation of changing the Amount Label
extension MainViewController: SpendingsPopupDelegate {
    func didSaveTransactiob() {
        updateAmount()
    }
}

// Extension for the CollectionView (again only use to just put it on the screen)
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private var categoriesData: [(name: String, amount: String, symbol: String, color: UIColor?)] {
        [
            ("Food", "120", "fork.knife", UIColor(named: "sky_blue")),
            ("Transport", "45", "car", UIColor(named: "bright_green")),
            ("Shopping", "310", "bag", UIColor(named: "bright_purple")),
            ("Bills", "220", "creditcard", UIColor(named: "sky_blue")),
            ("Health", "80", "cross", UIColor(named: "bright_green")),
            //("Fun", "60", "gamecontroller", UIColor(named: "bright_purple"))
        ]
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reusableID, for: indexPath) as! CategoryCollectionViewCell
        let item = categoriesData[indexPath.item]
        let icon = UIImage(systemName: item.symbol) // or UIImage(named: ...)
        cell.config(category: item.name, amount: item.amount, icon: icon, color: item.color?.withAlphaComponent(0.3))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle selection if needed
    }
}

