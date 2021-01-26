//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

public enum BookServiceError: Error {
    case emptyResult
}

/// A proxy service for searching books; current implementation use network;
/// Other implementation may use some cache or storages
public protocol BookService: class {

    func findBooks(query: String, completion: @escaping (Result<[Book], BookServiceError>) -> Void)
}

final class GoogleBookService: BookService {

    private enum QueryParameters: String {
        case maxResults = "maxResults"
        case startIndex = "startIndex"
        case query = "q"
    }

    private let network: Network

    /// The maximum number of results to return. The default is 10, and the maximum allowable value is 40.
    private let maxResults: Int = 40

    /// The position in the collection at which to start.
    private let startIndex: Int = 0

    private let baseURL: String = "https://www.googleapis.com/books/v1/volumes"

    init(network: Network) {
        self.network = network
    }

    func findBooks(query: String, completion: @escaping (Result<[Book], BookServiceError>) -> Void) {

        guard var url = URL(string: baseURL) else {
            completion(.failure(.emptyResult))
            return
        }

        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        var queryItems: [URLQueryItem] = []
        // TODO: add parameter to function to control pagination
        queryItems.append(URLQueryItem(name: QueryParameters.maxResults.rawValue, value: "\(maxResults)"))
        // TODO: add parameter to function to control pagination
        queryItems.append(URLQueryItem(name: QueryParameters.startIndex.rawValue, value: "\(startIndex)"))
        queryItems.append(URLQueryItem(name: QueryParameters.query.rawValue, value: "\(query)"))

        urlComponents?.queryItems = queryItems
        if let modifiedURL = urlComponents?.url {
            url = modifiedURL
        }

        let request = URLRequest(url: url)

        network.execute(request, expecting: BookSearchResponse.self) { (result) in
            switch result {
            case .success(let response):
                let books = response.items
                if books.isEmpty == false {
                    completion(.success(books))
                } else {
                    completion(.failure(.emptyResult))
                }
            case .failure(_):
                completion(.failure(.emptyResult))
            }
        }
    }
}


public struct BookSearchResponse: Codable {
    public let totalItems: Int
    public let items: [Book]
}
