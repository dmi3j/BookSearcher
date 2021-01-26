//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class BookEntryViewController: UIViewController {

    @IBOutlet private weak var bookTableView: UITableView!

    var viewModel: BookEntryViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let closeButton = UIBarButtonItem(barButtonSystemItem: .close,
                                          target: self,
                                          action: #selector(closeBarButtonPressed(_:)))
        navigationItem.leftBarButtonItem = closeButton
    }

    @objc
    func closeBarButtonPressed(_ sender: UIBarButtonItem) {
        viewModel?.close()
    }
}

// MARK: - UITableViewDataSource
extension BookEntryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let book: Book = viewModel?.book, let cell =
                tableView.dequeueReusableCell(withIdentifier: "BookEntryTableViewCell",
                                              for: indexPath) as? BookEntryTableViewCell else { return UITableViewCell() }
        cell.book = book
        return cell
    }
}

// MARK: - BookEntryVMVD
extension BookEntryViewController: BookEntryVMVD {

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.bookTableView.reloadData()
        }
    }
}
