//
//  MovieUseCase.swift
//  DNNetworkPlatform
//
//  Created by Duy Nguyen on 18/05/2022.
//

import RxSwift
import DNDomain

public protocol MovieUseCase {
    /// Retrieve Movies from API
    func getMovies() -> Single<[Movie]>
    
    /// Search Movies from API
    func searchMovies(searchText: String) -> Single<[Movie]>
}

public final class MovieUseCaseImpl: MovieUseCase {
    // MARK: - Public functions
    public func getMovies() -> Single<[Movie]> {
        return Single.create { observer -> Disposable in
            let manager = XNetworkManager<MovieEndPoint>()
            manager.request(target: .getMovieList) { (result: XPagingResult<Movie>) in
                switch result {
                case .success(let response):
                    observer(.success(response.results))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
    
    public func searchMovies(searchText: String) -> Single<[Movie]> {
        return Single.create { observer -> Disposable in
            let manager = XNetworkManager<MovieEndPoint>()
            manager.request(target: .searchMovies(searchText)) { (result: XPagingResult<Movie>) in
                switch result {
                case .success(let response):
                    observer(.success(response.results))
                case .failure(let error):
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
