//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    var book: Book? {
        didSet {
            guard let book = book else { return }

            titleLabel.text = book.title
            authorsLabel.text = book.authors.joined(separator: "\n")

            //TODO: optimize image download with some third party library
            activityIndicator.startAnimating()
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }

                guard let url = URL(string: book.smallThumbnail),
                      let imageData: Data = try? Data(contentsOf: url) else { return }
                let image = UIImage(data: imageData)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }

                    self.thumbnailImageView.image = image
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        thumbnailImageView.image = nil
        activityIndicator.stopAnimating()
    }
}
