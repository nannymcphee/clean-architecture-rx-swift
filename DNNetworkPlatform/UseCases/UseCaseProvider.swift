//
//  UseCaseProvider.swift
//  DNNetworkPlatform
//
//  Created by Duy Nguyen on 18/05/2022.
//

import DNDomain

public protocol UseCaseProvider {
    func makeMovieUseCase() -> MovieUseCase
}

public final class UseCaseProviderImpl: UseCaseProvider {
    // MARK: - Initializers
    public init(config: BuildConfig) {
        BuildConfig.default = config
    }
    
    // MARK: - Public functions
    public func makeMovieUseCase() -> MovieUseCase {
        return MovieUseCaseImpl()
    }
}
