//
//  Decodable+Ext.swift
//  iOSCleanArchitecture
//
//  Created by Duy Nguyen on 20/05/2022.
//

import Foundation

extension Decodable {
    static func create(from jsonFile: String) -> Self? {
        guard let path = Bundle.main.path(forResource: jsonFile, ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        else {
            return nil
        }
        return try? JSONDecoder().decode(Self.self, from: jsonData)
    }
}
