//
//  ViewModelTransformable.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

protocol ViewModelTransformable: AnyObject {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
}
