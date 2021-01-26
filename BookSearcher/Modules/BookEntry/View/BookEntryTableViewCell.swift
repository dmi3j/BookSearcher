//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class BookEntryTableViewCell: BookTableViewCell {

    @IBOutlet private weak var descriptionLabel: UILabel!

    override func update(with book: Book) {
        titleLabel.text = book.title
        authorsLabel.text = book.authors.joined(separator: "\n")

        //TODO: optimize image download with some third party library
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }

            guard let url = URL(string: book.bigThumbnail),
                  let imageData: Data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: imageData)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.thumbnailImageView.image = image
                self.activityIndicator.stopAnimating()
            }
        }
        descriptionLabel?.text = book.description
    }
}
