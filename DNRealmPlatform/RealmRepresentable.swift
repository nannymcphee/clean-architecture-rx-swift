//
//  RealmRepresentable.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

protocol RealmRepresentable {
    associatedtype RealmType: DomainConvertibleType

    var uid: String { get }

    func asRealm() -> RealmType
}
