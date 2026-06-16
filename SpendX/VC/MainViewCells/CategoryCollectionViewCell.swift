//This file is just for visuals, thus will not contain no explanations from me
import UIKit

//MARK: Custom cell for CollectionView

final class CategoryCollectionViewCell: UICollectionViewCell {
    static let reusableID = "CategoryCellID"

    // Circular blue background container (16x16)
    private let iconContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 9 // 16 / 2
        v.layer.masksToBounds = true
        return v
    }()

    // System image inside with 3pt padding, white tint
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        return iv
    }()

    private let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = FontBook.medium(size: 12)
        l.textColor = .categoryGrey
        l.textAlignment = .left
        return l
    }()

    private let amountLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = FontBook.medium(size: 12)
        l.textColor = .categoryGrey
        l.textAlignment = .right
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(named: "sky_blue")?.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 5, leading: 4, bottom: 5, trailing: 9)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        // Build hierarchy
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)

        let textStack = UIStackView(arrangedSubviews: [nameLabel, amountLabel])
        textStack.axis = .horizontal
        textStack.alignment = .center
        textStack.distribution = .equalSpacing
        textStack.spacing = 0
        textStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStack)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            // Icon container size 16x16 and align to leading, centered vertically
            iconContainer.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 18),
            iconContainer.heightAnchor.constraint(equalToConstant: 18),

            // Icon inside with 2pt padding on each side
            iconView.topAnchor.constraint(equalTo: iconContainer.topAnchor, constant: 2),
            iconView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 2),
            iconView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -2),
            iconView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: -2),

            // Text stack to the right of icon with spacing
            textStack.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 4),
            textStack.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            textStack.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            textStack.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            textStack.widthAnchor.constraint(equalToConstant: 142)
        ])

        // Improve intrinsic layout behavior
        nameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        amountLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        amountLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

    func config(category: String, amount: String, icon: UIImage?, color: UIColor?) {
        contentView.backgroundColor = color
        nameLabel.text = category
        amountLabel.text = amount + " $"
        // Ensure template rendering for tint to apply to SF Symbols
        if let icon = icon?.withRenderingMode(.alwaysTemplate) {
            iconView.image = icon
        } else {
            iconView.image = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.bounds.height / 2
    }
}

