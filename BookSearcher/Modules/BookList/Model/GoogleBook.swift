//  Copyright © 2021 Dmitrijs Beloborodovs. All rights reserved.

import Foundation

public struct GoogleBook: Book {
    public var title: String { volumeInfo.title }
    public var authors: [String] { volumeInfo.authors ?? [] }
    public var smallThumbnail: String {
        //TODO: move this error fixing to some other place
        volumeInfo.imageLinks?.smallThumbnail
            .replacingOccurrences(of: "&;amp;", with: "&")
            .replacingOccurrences(of: "&amp;", with: "&") ?? ""
    }
    public var bigThumbnail: String {
        //TODO: move this error fixing to some other place
        volumeInfo.imageLinks?.thumbnail
            .replacingOccurrences(of: "&;amp;", with: "&")
            .replacingOccurrences(of: "&amp;", with: "&") ?? ""
    }

    public var description: String { volumeInfo.description ?? "n/a" }

    private let volumeInfo: VolumeInfo

    enum CodingKeys: String, CodingKey {
        case volumeInfo
    }
}

private struct VolumeInfo: Codable {
    public let title: String
    public let description: String?
    public let authors: [String]?
    public let imageLinks: ImageLinks?

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case authors
        case imageLinks
    }
}

private struct ImageLinks: Codable {
    public let smallThumbnail: String
    public let thumbnail: String
}
