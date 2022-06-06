//
//  BaseUseCase.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

import RxSwift
import RealmSwift

public class BaseUseCase {
    // MARK: - Initialziers
    public init(configuration: Realm.Configuration, excutionQueue: DispatchQueue) {
        self.configuration = configuration
        self.excutionQueue = excutionQueue
        self.scheduler = ConcurrentDispatchQueueScheduler(queue: excutionQueue)
    }

    // MARK: - Variables
    internal let configuration: Realm.Configuration
    internal let excutionQueue: DispatchQueue
    internal let scheduler: ConcurrentDispatchQueueScheduler

    var realm: Realm? {
        var _realm: Realm?
        do {
            _realm = try Realm(configuration: configuration)
        } catch {
            print(error.localizedDescription)
            assert(false)
        }
        return _realm
    }

    // MARK: - Internal functions
    func createSingleExcution<T>(excution: @escaping (_ realm: Realm, _ observer: Single<T>.SingleObserver) -> ()) -> Single<T> {
        return Single.create { [weak self] (observer) -> Disposable in
            self?.excutionQueue.async { [weak self] in
                guard
                    let self = self,
                    let realm = try? Realm(configuration: self.configuration)
                else { return }

                excution(realm, observer)
            }
            return Disposables.create()
        }
    }

    func createExcution(excution: @escaping (_ realm: Realm) -> ()) {
        excutionQueue.async { [weak self] in
            guard
                let self = self,
                let realm = try? Realm(configuration: self.configuration)
            else { return }

            excution(realm)
        }
    }
}
