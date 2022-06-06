//
//  MovieUseCase.swift
//  DNRealmPlatform
//
//  Created by Duy Nguyen on 30/05/2022.
//

import DNDomain
import RealmSwift
import RxSwift

public protocol MovieUseCase {
    /// Save Movies to local storage, returns Single<Void>
    func saveSync(_ movies: [Movie]) -> Single<Void>
    
    /// Save Movies to local storage
    func save(_ movies: [Movie])
    
    /// Retrieve Movies from local storage
    func getMovies() -> Single<[Movie]>
    
    /// Retrieve Movie with specific trackID
    func getMovie(trackID: Int) -> Movie?
    
    /// Search Movies from local storage
    func searchMovies(searchText: String) -> Single<[Movie]>
    
    /// Retrieve favorited Movies from local storage
    func getFavoriteMovies() -> Single<[Movie]>
    
    /// Update movie's favorite status
    func toggleFavorite(movie: Movie, isFavorited: Bool) -> Single<Void>
}

public final class MovieUseCaseImpl: BaseUseCase, MovieUseCase {
    // MARK: - Public functions
    public func saveSync(_ movies: [Movie]) -> Single<Void> {
        createSingleExcution { [weak self] (realm, single) in
            self?.save(movies: movies, realm: realm)
            single(.success(()))
        }
    }
    
    public func save(_ movies: [Movie]) {
        createExcution { [weak self] realm in
            self?.save(movies: movies, realm: realm)
        }
    }
    
    public func getMovies() -> Single<[Movie]> {
        return createSingleExcution { realm, observer in
            let results = realm
                .objects(RMMovie.self)
                .sorted(byKeyPath: "primaryGenreName", ascending: true)
            observer(.success(results.mapToDomain()))
        }
    }
    
    public func getMovie(trackID: String) -> Single<Movie?> {
        return createSingleExcution { realm, observer in
            let result = realm
                .objects(RMMovie.self)
                .filter("trackID == \"\(trackID)\"")
                .first
            let movie = result?.asDomain()
            observer(.success(movie))
        }
    }
    
    public func getMovie(trackID: Int) -> Movie? {
        let result = realm?
            .objects(RMMovie.self)
            .filter("trackID == \"\(trackID)\"")
            .first
        return result?.asDomain()
    }
    
    public func searchMovies(searchText: String) -> Single<[Movie]> {
        createSingleExcution { realm, observer in
            let query = String(format: "\(#keyPath(RMMovie.trackName)) CONTAINS[cd] '%@'", searchText)
            let predicate = NSPredicate(format: "\(query)")
            let results = realm
                .objects(RMMovie.self)
                .filter("\(predicate)")
                .sorted(byKeyPath: "primaryGenreName", ascending: true)
            let finalResult = Array(results)
                .compactMap { $0 }
                .mapToDomain()
            
            observer(.success(finalResult))
        }
    }
    
    public func getFavoriteMovies() -> Single<[Movie]> {
        return createSingleExcution { realm, observer in
            let results = realm
                .objects(RMMovie.self)
                .filter("isFavorited = true")
                .sorted(byKeyPath: "favoriteTimestamp", ascending: false)
            observer(.success(results.mapToDomain()))
        }
    }
    
    public func toggleFavorite(movie: Movie, isFavorited: Bool) -> Single<Void> {
        return createSingleExcution { [weak self] realm, observer in
            let movie = movie.asRealm()
            movie.isFavorited = isFavorited
            movie.favoriteTimestamp = isFavorited ? Date().timeIntervalSince1970 : 0.0
            let results = realm
                .objects(RMMovie.self)
                .filter("trackID == \"\(movie.trackID)\"")
            
            if results.count > 0 {
                try? realm.safeWrite {
                    realm.add(movie, update: .modified)
                    observer(.success(()))
                }
            } else {
                if let movie = movie.asDomain() {
                    self?.save(movies: [movie], realm: realm)
                    observer(.success(()))
                }
            }
        }
    }
    
    // MARK: - Private functions
    private func save(movies: [Movie], realm: Realm) {
        try? realm.safeWrite {
            let rmMovies = movies.map { $0.asRealm() }
            for movie in rmMovies {
                if let obj = realm.objects(RMMovie.self).filter("trackID == '\(movie.trackID)'").first {
                    obj.payload = movie.payload
                } else {
                    realm.add(movie, update: .modified)
                }
            }
        }
    }
}

