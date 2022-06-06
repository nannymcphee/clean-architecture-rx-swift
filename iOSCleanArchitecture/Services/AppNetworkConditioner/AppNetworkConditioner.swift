//
//  AppNetworkConditioner.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 20/05/2022.
//

import RxSwift
import RxRelay

protocol AppNetworkConditioner {
    var isReachableObservable: Observable<Bool> { get }
    func start()
}

final class AppNetworkConditionerImpl: AppNetworkConditioner {
    // MARK: - Variables
    public var isReachableObservable: Observable<Bool> {
        return isReachableRelay.asObservable()
    }
    private var isReachableRelay = BehaviorRelay<Bool>(value: false)
    private let service: ReachabilityService
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    public init(service: ReachabilityService) {
        self.service = service
    }
    
    // MARK: - Public functions
    public func start() {
        service.reachability
            .observe(on: MainScheduler.instance)
            .map(\.reachable)
            .distinctUntilChanged()
            .bind(to: isReachableRelay)
            .disposed(by: disposeBag)
    }
}
