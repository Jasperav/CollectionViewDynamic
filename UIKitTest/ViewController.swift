import UIKit

class ViewController: UIViewController {

    let collectionView = EmojiReactionCollectionView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(collectionView)

        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        DispatchQueue.global().async {
            var count = 0
            while count < 2 {
                count += 1

                DispatchQueue.main.async {
                    self.collectionView.addEmoji(emoji: .init(emoji: ["😃", "🐻", "🍔"].randomElement()!, amount: count))
                }

                sleep(3)
            }
        }
    }
}

struct Emoji {
    let emoji: String
    let amount: Int

    func size() -> CGSize {
        let fontAttributesEmoji =
            [NSAttributedString.Key.font: EmojiReactionCell.font]
        let sizeOfEmoji = (emoji as NSString).size(withAttributes: fontAttributesEmoji)

        let fontAttributesAmount =
            [NSAttributedString.Key.font: EmojiReactionCell.font]
        let sizeOfLabel = ("\(amount)" as NSString).size(withAttributes: fontAttributesAmount)

        let width = sizeOfEmoji.width + sizeOfLabel.width
        let height = max(sizeOfEmoji.height, sizeOfLabel.height)

        // Add some breath
        let breath: CGFloat = 5

        return .init(width: width + breath, height: height + breath)
    }
}

class EmojiReactionCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private var emojis = [Emoji]()

    var heightAnchor_: NSLayoutConstraint!
    var widthAnchor_: NSLayoutConstraint!

    init() {
        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        super.init(frame: .zero, collectionViewLayout: layout)

        isScrollEnabled = false

        register(EmojiReactionCell.self, forCellWithReuseIdentifier: EmojiReactionCell.reuseIdentifier)

        dataSource = self
        delegate = self

        heightAnchor_ = heightAnchor.constraint(equalToConstant: 1)
        heightAnchor_.isActive = true

        widthAnchor_ = widthAnchor.constraint(equalToConstant: 1)
        widthAnchor_.isActive = true

        contentInset = .zero
    }

    required init?(coder: NSCoder) {
        fatalError("not used")
    }

    func addEmoji(emoji: Emoji) {
        emojis.append(emoji)

        var width: CGFloat = 0

        for emoji in emojis {
            width += emoji.size().width
        }

        let finalWidth = min(width, 280)

        // Add some breath
        widthAnchor_.constant = finalWidth + 5

        reloadData()

        heightAnchor_.constant = collectionViewLayout.collectionViewContentSize.height
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: EmojiReactionCell.reuseIdentifier, for: indexPath) as! EmojiReactionCell
        let emoji = emojis[indexPath.row]

        cell.configure(emoji: emoji)

        return cell
    }

    // https://stackoverflow.com/a/52428617/7715250
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        emojis[indexPath.row].size()
    }
}

class EmojiReactionCell: UICollectionViewCell {
    static let reuseIdentifier = "\(EmojiReactionCell.self)"
    static let font = UIFont.systemFont(ofSize: 17)

    let emojiLabel = UILabel(frame: .zero)
    let count = UILabel(frame: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)

        emojiLabel.font = Self.font
        count.font = Self.font

        count.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        backgroundColor = .systemGray

        let stackView = UIStackView(arrangedSubviews: [emojiLabel, count])

        stackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true

        emojiLabel.text = "test"
    }

    required init?(coder: NSCoder) {
        fatalError("not used")
    }

    func configure(emoji: Emoji) {
        emojiLabel.text = emoji.emoji
        count.text = "\(emoji.amount)"
    }
}
