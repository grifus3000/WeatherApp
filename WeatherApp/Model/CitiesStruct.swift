//
//  CitiesStruct.swift
//  WeatherApp
//
//  Created by Grifus on 31.10.2021.
//

import Foundation

struct CitiesElement: Codable {
    let id: Int?
    let name, state, country: String?
    let coord: CitiesCoord?
}

// MARK: - Coord
struct CitiesCoord: Codable {
    let lon, lat: Double?
}

typealias Cities = [CitiesElement]
