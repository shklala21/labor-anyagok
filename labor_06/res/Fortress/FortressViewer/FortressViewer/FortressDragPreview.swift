import UIKit

class FortressDragPreview: UIView {

  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    return imageView
  }()
  private var nameLabel: UILabel = {
    let nameLabel = UILabel()
    nameLabel.textAlignment = .center
    nameLabel.font = .preferredFont(forTextStyle: .body)
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    nameLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
    return nameLabel
  }()
  private var descriptionLabel: UILabel = {
    let descriptionLabel = UILabel()
    descriptionLabel.numberOfLines = 0
    descriptionLabel.lineBreakMode = .byWordWrapping
    descriptionLabel.font = .preferredFont(forTextStyle: .caption2)
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .vertical)
    descriptionLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
    return descriptionLabel
  }()
  private var stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = 0
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    stackView.addArrangedSubview(imageView)
    stackView.addArrangedSubview(nameLabel)
    stackView.addArrangedSubview(descriptionLabel)
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
      topAnchor.constraint(equalTo: stackView.topAnchor),
      stackView.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 1),
      bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
    ])
  }

  func setContent(image: UIImage, name: String, shortDescription: String) {
    imageView.image = image
    nameLabel.text = name
    descriptionLabel.text = shortDescription
  }
}
