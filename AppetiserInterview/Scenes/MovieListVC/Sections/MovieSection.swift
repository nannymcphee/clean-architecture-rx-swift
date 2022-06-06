//
//  MovieSection.swift
//  AppetiserInterview
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxDataSources
import DNDomain

struct MovieSection: AnimatableSectionModelType {
    // MARK: - Typealiases
    typealias Item = MovieItem
    typealias Identity = String
    
    // MARK: - Variables
    var items: [MovieItem]
    var identity: String {
        return items.first?.identity ?? UUID().uuidString
    }
    var sectionTitle: String = ""
    
    // MARK: - Initializers
    init(items: [MovieItem], sectionTitle: String) {
        self.items = items
        self.sectionTitle = sectionTitle
    }
    
    internal init(original: MovieSection, items: [MovieItem]) {
        self = original
        self.items = items
    }
}

struct MovieItem: Equatable, IdentifiableType {
    // MARK: - Typealiases
    typealias Identity = String
    
    // MARK: - Variables
    let movie: Movie

    var identity: String {
        "\(movie.trackID)"
    }
    
    var releaseDateString: String {
        return Date.convertDate(from: movie.releaseDate,
                                currentFormat: Date.dateTimeZoneFormat,
                                newFormat: Date.formatddMMyyyy)
    }
    
    // MARK: - Initializers
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: - Equaltable
    static func == (lhs: MovieItem, rhs: MovieItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

