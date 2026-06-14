import UIKit

class SpendingsPopupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black.withAlphaComponent(0.5)
        
        //MARK: Container
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 12
        container.layer.masksToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            container.heightAnchor.constraint(equalToConstant: 400),
            container.widthAnchor.constraint(equalToConstant: 370)
        ])
        
        [closeButton, titleLabel, amountLabel, amountTextField, currencyButton, categoryNameLabel, categoryNameTextField, colorButton, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -8),
            
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            amountLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 30),
            
            amountTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            amountTextField.trailingAnchor.constraint(equalTo: currencyButton.leadingAnchor, constant: -12),
            amountTextField.heightAnchor.constraint(equalToConstant: 40),
            
            currencyButton.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 8),
            currencyButton.centerYAnchor.constraint(equalTo: amountTextField.centerYAnchor),
            currencyButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            currencyButton.widthAnchor.constraint(equalToConstant: 20),
            
            categoryNameLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            categoryNameLabel.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: 25),
            
            categoryNameTextField.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            categoryNameTextField.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8),
            categoryNameTextField.trailingAnchor.constraint(equalTo: colorButton.leadingAnchor, constant: -12),
            categoryNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            colorButton.topAnchor.constraint(equalTo: categoryNameLabel.bottomAnchor, constant: 8),
            colorButton.centerYAnchor.constraint(equalTo: categoryNameTextField.centerYAnchor),
            colorButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            colorButton.widthAnchor.constraint(equalToConstant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: categoryNameTextField.bottomAnchor, constant: 25),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    //MARK: UIView
    
    private var closeButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        let image = UIImage(systemName: "xmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("New Expence", font: FontBook.medium(size: 20), color: .black, kern: 0)
        return label
    }()
    
    private var amountLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("Amount", font: FontBook.medium(size: 13), color: .categoryGrey, kern: 0)
        return label
    }()
    
    private var amountTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Type sum of the expence", attributes: [
            .font: FontBook.regular(size: 12),
            .foregroundColor: UIColor.categoryGrey
        ])
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.backgroundColor = .lightLightGrey
        return textField
    }()
    
    private var currencyButton: UIButton = {
       let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .regular)
        let image = UIImage(systemName: "dollarsign", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .categoryGrey
        button.backgroundColor = .lightLightGrey
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.attributedText = AttributedTextBuilder.make("Category", font: FontBook.medium(size: 13), color: .categoryGrey, kern: 0)
        return label
    }()
    
    private var categoryNameTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Type category name", attributes: [
            .font: FontBook.regular(size: 12),
            .foregroundColor: UIColor.categoryGrey
        ])
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.backgroundColor = .lightLightGrey
        return textField
    }()
    
    private var colorButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink.withAlphaComponent(0.3)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        return button
    }()
    
    private var saveButton: UIButton = {
       let button = UIButton()
        let text = AttributedTextBuilder.make("Save", font: FontBook.medium(size: 16), color: .categoryGrey, kern: 0)
        button.setAttributedTitle(text, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.backgroundColor = .lightLightGrey
        return button
    }()
    
    @objc func closePopup() {
        dismiss(animated: true)
    }
}
