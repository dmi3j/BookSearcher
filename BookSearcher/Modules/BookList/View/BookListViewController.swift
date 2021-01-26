//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import UIKit

class BookListViewController: UIViewController {

    @IBOutlet private weak var bookSearchBar: UISearchBar!
    @IBOutlet private weak var bookTableView: UITableView!

    var viewModel: BookListViewModel? {
        didSet {
            viewModel?.viewDelegate = self
        }
    }

    lazy var alertController: UIAlertController = {
        UIAlertController(title: "Searching...", message: nil, preferredStyle: .alert)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Book Searcher"
        bookSearchBar.searchTextField.accessibilityLabel = "bookSearchField"
    }
}

// MARK: - UITableViewDataSource
extension BookListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.bookCount ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let book: Book = viewModel?.book(at: indexPath.row), let cell =
                tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell",
                                              for: indexPath) as? BookTableViewCell else { return UITableViewCell() }
        cell.book = book
        return cell
    }
}

// MARK: - UITableViewDelegate
extension BookListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectBook(at: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate
extension BookListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard searchBar.text?.isEmpty == false else { return }
        viewModel?.searchBook(using: searchBar.text ?? "")
    }
}

// MARK: - UIScrollViewDelegate
extension BookListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /// hide keyboard if user scrolls up
        if scrollView.contentOffset.y < 0 {
            bookSearchBar.resignFirstResponder()
        }
    }
}

// MARK: - BookListVMVD
extension BookListViewController: BookListVMVD {

    func showSearchProgress() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.bookSearchBar.resignFirstResponder()

            //TODO: make better progress display
            self.present(self.alertController, animated: true, completion: nil)
        }
    }

    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.bookSearchBar.resignFirstResponder()
            self.dismiss(animated: false, completion: nil)
            self.bookTableView.reloadData()
        }
    }
}
