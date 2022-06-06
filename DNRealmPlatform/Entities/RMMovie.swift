//
//  RMMovie.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

import DNDomain
import Realm
import RealmSwift

class RMMovie: Object {
    @objc dynamic var trackID: String = ""
    @objc dynamic var trackName: String = ""
    @objc dynamic var artworkUrl100: String = ""
    @objc dynamic var artworkUrl1024: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var primaryGenreName: String = ""
    @objc dynamic var longDescription: String = ""
    @objc dynamic var shortDescription: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var payload: String = ""
    @objc dynamic var trackPrice: Double = 0.0
    @objc dynamic var isFavorited: Bool = false
    @objc dynamic var favoriteTimestamp: Double = 0.0
    
    override public static func primaryKey() -> String? {
        return "trackID"
    }
}

extension Movie {
    func asRealm() -> RMMovie {
        return RMMovie.build { object in
            object.trackID = "\(self.trackID)"
            object.trackName = self.trackName
            object.artworkUrl100 = self.artworkUrl100
            object.artworkUrl1024 = self.artworkUrl1024
            object.currency = self.currency
            object.primaryGenreName = self.primaryGenreName
            object.longDescription = self.longDescription
            object.shortDescription = self.shortDescription
            object.releaseDate = self.releaseDate
            object.trackPrice = self.trackPrice
            object.isFavorited = self.isFavorited
            object.favoriteTimestamp = self.favoriteTimestamp
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(self) {
                object.payload = String.init(data: data, encoding: .utf8) ?? ""
            }
        }
    }
}

extension RMMovie: DomainConvertibleType {
    func asDomain() -> Movie? {
        let decoder = JSONDecoder()
        var message: Movie?
        if let data = payload.data(using: .utf8) {
            message = try? decoder.decode(Movie.self, from: data)
        }
        message?.isFavorited = self.isFavorited
        message?.favoriteTimestamp = self.favoriteTimestamp
        return message
    }
}
