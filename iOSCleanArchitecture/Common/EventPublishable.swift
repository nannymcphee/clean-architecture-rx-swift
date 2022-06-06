//
//  EventPublishable.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 30/05/2022.
//

import RxSwift

protocol EventPublishable {
    associatedtype Event
    var eventPublisher: PublishSubject<Event> { get set }
}
