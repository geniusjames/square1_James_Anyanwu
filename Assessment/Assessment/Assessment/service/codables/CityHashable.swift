//
//  CityHashable.swift
//  Assessment
//
//  Created by Geniusjames on 31/07/2022.
//

import Foundation

extension City: Hashable {
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
