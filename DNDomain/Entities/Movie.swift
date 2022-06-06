//
//  Movie.swift
//  DNDomain
//
//  Created by Duy Nguyen on 18/05/2022.
//

import Foundation

public struct Movie: Codable {
    public let trackName: String
    public let artworkUrl100: String
    public let currency: String
    public let primaryGenreName: String
    public let longDescription: String
    public let releaseDate: String
    public let shortDescription: String
    public let trackID: Int
    public let trackPrice: Double
    public var artworkUrl1024: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "1024x768")
    }
    public var isFavorited: Bool = false
    public var favoriteTimestamp: Double = 0.0

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case trackName, trackPrice, artworkUrl100
        case releaseDate, currency, primaryGenreName, longDescription
        case shortDescription
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.trackID = values.decodex(key: .trackID, defaultValue: 0)
        self.trackName = values.decodex(key: .trackName, defaultValue: "")
        self.artworkUrl100 = values.decodex(key: .artworkUrl100, defaultValue: "")
        self.trackPrice = values.decodex(key: .trackPrice, defaultValue: 0)
        self.releaseDate = values.decodex(key: .releaseDate, defaultValue: "")
        self.currency = values.decodex(key: .currency, defaultValue: "")
        self.primaryGenreName = values.decodex(key: .primaryGenreName, defaultValue: "")
        self.longDescription = values.decodex(key: .longDescription, defaultValue: "")
        self.shortDescription = values.decodex(key: .shortDescription, defaultValue: "")
        self.isFavorited = false
        self.favoriteTimestamp = 0.0
    }
    
    public mutating func toggleFavorite() {
        isFavorited = !isFavorited
    }
}
