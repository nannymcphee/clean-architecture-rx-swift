//
//  Observable+Ext.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

import RxSwift

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {
    typealias DomainType = Element.Iterator.Element.DomainType
    
    func mapToDomain() -> Observable<[DomainType]> {
        return compactMap { sequence -> [DomainType] in
            return sequence.mapToDomain()
        }
    }
}

extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias Element = Iterator.Element
    func mapToDomain() -> [Element.DomainType] {
        return compactMap {
            return $0.asDomain()
        }
    }
}
