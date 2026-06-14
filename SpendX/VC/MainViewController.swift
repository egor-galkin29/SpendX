import UIKit

final class MainViewController: UIViewController {
    //MARK: Private Properties
    
    private var segments: [(value: CGFloat, color: UIColor)] = []
    
    private let periodButtons = PeriodButtons()
    private let filterButtons = FilterButtons()
    private let spendAddButtons = SpendAddButtons()
    
    //MARK: UIView
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.attributedText = AttributedTextBuilder.make("Account name", font: FontBook.bold(size: 24), color: .black, kern: -1)
        return label
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: filterButtons.all)
        
        stack.axis = .horizontal
        stack.spacing = 14
        stack.alignment = .center
        
        return stack
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("18 567 $", font: FontBook.semiBold(size: 32), color: .black, kern: -1)
        return label
    }()
    
    private lazy var addStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: spendAddButtons.all)
        
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        
        return stack
    }()
    
    private let spendingsLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("Spendings", font: FontBook.regular(size: 14), color: .black, kern: Int(-0.5))
        return label
    }()
    
    //adds a view for the circle graph
    private let chartView = UIView()
    
    private lazy var periodStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: periodButtons.all)
        
        stack.backgroundColor = .lightLightGrey
        stack.layer.cornerRadius = 13
        stack.clipsToBounds = true
        stack.distribution = .fillEqually
        return stack
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        spendAddButtons.all.forEach { button in
            button.addTarget(self, action: #selector(handleSpendAddButtonTap(_:)), for: .touchUpInside)
        }
        
        segments = [
            (70, .skyBlue),
            (19, .brightPurple),
            (11, .brightGreen)
        ]
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        
        if chartView.layer.sublayers?.isEmpty ?? true {
            createDonutChart(segments: segments, size: 192)
        }
    }
    
    //MARK: Private Methods
    
    private func setupView() {
        [titleLabel, filterStackView, amountLabel, addStackView, spendingsLabel, chartView, periodStackView, categoryCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: guide.topAnchor, constant: 8),
            
            filterStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25),
            
            amountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: filterStackView.bottomAnchor, constant: 25),
            
            addStackView.centerYAnchor.constraint(equalTo: amountLabel.centerYAnchor),
            addStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
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
    
    @objc private func handleSpendAddButtonTap(_ sender: UIButton) {
        // You can differentiate buttons by tag, accessibilityIdentifier, or comparing instances.
        if sender === spendAddButtons.add {
            let popup = SpendingsPopupViewController()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            present(popup, animated: true)
        } else if sender === spendAddButtons.spend {
            let popup = SpendingsPopupViewController()
            popup.modalPresentationStyle = .overFullScreen
            popup.modalTransitionStyle = .crossDissolve
            present(popup, animated: true)        }
    }
}

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

