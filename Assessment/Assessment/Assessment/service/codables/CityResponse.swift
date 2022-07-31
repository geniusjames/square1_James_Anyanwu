//
//  CityResponse.swift
//  Assessment
//
//  Created by Geniusjames on 30/07/2022.
//

import Foundation


import Foundation

// MARK: - WorldCities
struct WorldCities: Codable {
    let data: CityData
    let time: Int
}

// MARK: - CityData
struct CityData: Codable {
    let items: [City]
    let pagination: Pagination
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name, localName: String
    let lat, lng: Double?
    let createdAt: String = "2018-01-07 17:08:01"
    let updatedAt: String
    let countryID: Int

    enum CodingKeys: String, CodingKey {
        case id, name
        case localName = "local_name"
        case lat, lng
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case countryID = "country_id"
    }
}

// MARK: - Pagination
struct Pagination: Codable {
    let currentPage, lastPage, perPage, total: Int

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case lastPage = "last_page"
        case perPage = "per_page"
        case total
    }
}
