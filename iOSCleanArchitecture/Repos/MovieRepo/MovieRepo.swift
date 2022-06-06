//
//  MovieRepo.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import Resolver
import DNDomain
import DNNetworkPlatform
import DNRealmPlatform

public protocol MovieRepo {
    /// Retrieve movies from Local & API
    func getMovies() -> Observable<[Movie]>
    
    /// Retrieve favorited movies
    func getFavoriteMovies() -> Observable<[Movie]>
    
    /// Search movies from API
    func searchMovies(searchText: String) -> Observable<[Movie]>
    
    /// Search movies from local storage
    func searchMoviesLocal(searchText: String) -> Observable<[Movie]>
    
    /// Update movie's favorite status
    func toggleFavorite(movie: Movie, isFavorited: Bool) -> Observable<Void>
}

public class MovieRepoImpl: MovieRepo {
    // MARK: - Variables
    @Injected private var moviesApi: DNNetworkPlatform.MovieUseCase
    @Injected private var moviesRealm: DNRealmPlatform.MovieUseCase
    @Injected private var dispatchQueue: ConcurrentDispatchQueueScheduler
    
    // MARK: - Public functions
    public func getMovies() -> Observable<[Movie]> {
        let defaultMovies = MovieListResponse.create(from: "default_movies")?.results ?? []
        // Collect Movies from local & remote
        return Observable.merge(
            moviesRealm.getMovies()
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, movies -> Observable<[Movie]> in
                    // Save & load default movies
                    if !Preferences[.didSaveDefaultMovies] {
                        return Observable.just(owner.moviesRealm.save(defaultMovies))
                            .do(onNext: { _ in
                                Preferences[.didSaveDefaultMovies] = true
                            })
                            .flatMap { _ -> Observable<[Movie]> in
                                return .just(defaultMovies)
                            }
                    }
                    
                    return .just(movies)
                }
                .catchAndReturn([]),
            moviesApi.getMovies()
                .asObservable()
                .withUnretained(self)
                .flatMap { (owner, movies) -> Observable<Void> in
                    // Save movies to local
                    return owner.moviesRealm
                        .saveSync(movies)
                        .asObservable()
                }
                .withUnretained(self)
                .flatMap { (owner, _) -> Observable<[Movie]> in
                    // Return local movies
                    return owner.moviesRealm.getMovies()
                        .catchAndReturn([])
                        .asObservable()
                }
        )
        .subscribe(on: dispatchQueue)
    }
    
    public func getFavoriteMovies() -> Observable<[Movie]> {
        return moviesRealm.getFavoriteMovies().asObservable()
    }
    
    public func searchMovies(searchText: String) -> Observable<[Movie]> {
        return moviesApi.searchMovies(searchText: searchText)
            .catchAndReturn([])
            .asObservable()
            .withUnretained(self)
            .flatMap { owner, movies -> Observable<[Movie]> in
                var _movies = movies
                // Update favorite status with local
                for (index, movie) in _movies.enumerated() {
                    if let localMovie = owner.moviesRealm.getMovie(trackID: movie.trackID) {
                        _movies[index].isFavorited = localMovie.isFavorited
                    }
                }
                return .just(_movies)
            }
    }
    
    public func searchMoviesLocal(searchText: String) -> Observable<[Movie]> {
        return moviesRealm.searchMovies(searchText: searchText)
            .catchAndReturn([])
            .asObservable()
    }
    
    public func toggleFavorite(movie: Movie, isFavorited: Bool) -> Observable<Void> {
        return moviesRealm.toggleFavorite(movie: movie, isFavorited: isFavorited).asObservable()
    }
}
