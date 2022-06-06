//
//  ViewModelTrackable.swift
//  NetflixClone
//
//  Created by Duy Nguyen on 31/03/2022.
//

import Foundation

protocol ViewModelTrackable: AnyObject {
    var loadingIndicator: ActivityIndicator { get }
    var errorTracker: ErrorTracker { get }
}
