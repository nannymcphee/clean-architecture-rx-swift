//
//  Realm+Ext.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

import Foundation
import Realm
import RealmSwift
import RxSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension RealmSwift.SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}

extension Realm {
    internal func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}

extension Realm {
    func save<R: RealmRepresentable>(entity: R) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                try self.safeWrite {
                    self.add(entity.asRealm(), update: .modified)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func save<R: RealmRepresentable>(entities: [R]) -> Observable<Void> where R.RealmType: Object  {
        return Observable.create { observer in
            do {
                try self.safeWrite {
                    self.add(entities.compactMap({ $0.asRealm() }) , update: .modified)
                }
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<R: RealmRepresentable>(entity: R) -> Observable<Void> where R.RealmType: Object {
        return Observable.create { observer in
            do {
                guard let object = self.object(ofType: R.RealmType.self,
                                               forPrimaryKey: entity.uid) else { return Disposables.create() }
                try self.safeWrite {
                    self.delete(object)
                }
                
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func delete<R: RealmRepresentable>(entities: [R]) -> Observable<Void>  where R.RealmType: Object {
        return Observable.from(entities)
            .flatMap { delete(entity: $0) }
    }
}

// MARK: - Will remove after change code
extension Realm {
    func save<R: RealmRepresentable>(entity: R) where R.RealmType: Object  {
        try? self.safeWrite {
            self.add(entity.asRealm(), update: .modified)
        }
    }
    
    func save<R: RealmRepresentable>(entities: [R]) where R.RealmType: Object  {
        try? self.safeWrite {
            self.add(entities.map({ $0.asRealm() }), update: .modified)
        }
    }
    
    func delete<R: RealmRepresentable>(entity: R) where R.RealmType: Object {
        guard let object = self.object(ofType: R.RealmType.self, forPrimaryKey: entity.uid) else {
            return
        }
        try? self.safeWrite {
            self.delete(object)
        }
    }
    
    func delete<R: RealmRepresentable>(entities: [R]) where R.RealmType: Object {
        entities.forEach { (object) in
            if let object = self.object(ofType: R.RealmType.self, forPrimaryKey: object.uid) {
                try? self.safeWrite {
                    self.delete(object)
                }
            }
        }
    }
}
