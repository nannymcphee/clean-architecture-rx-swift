//
//  DomainConvertibleType.swift
//  DNDomain
//
//  Created by Duy Nguyen on 19/05/2022.
//

public protocol DomainConvertibleType {
    associatedtype DomainType

    func asDomain() -> DomainType?
}
