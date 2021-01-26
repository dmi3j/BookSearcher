//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

public enum NetworkError: Error {
    case noData
}

public protocol Network {
    func execute<T: Decodable>(_ request: URLRequest, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: Network {

    private lazy var urlSession: URLSession = {
        let internalURLSession = URLSession(configuration: .default)
        return internalURLSession
    }()

    func execute<T: Decodable>(_ request: URLRequest, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        urlSession.dataTask(with: request) { (data, urlResponse, error) in
            guard error == nil else { completion(.failure(error!)); return }
            guard let data = data else { completion(.failure(NetworkError.noData)); return }

            let result: T
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode(T.self, from: data)
            } catch {
                debugPrint(error)
                //TODO: add proper error display
                completion(.failure(error))
                return
            }

            completion(.success(result))

        }.resume()
    }
}
