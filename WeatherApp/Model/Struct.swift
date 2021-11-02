//
//  model.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import Foundation

// MARK: - Welcome
struct WeatherData: Codable {
    let coord: Coord?
    let weather: [Weather]?
    let base: String?
    let main: Main
    let visibility: Double?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Double?
    let sys: Sys?
    let timezone, id: Double?
    let name: String
    let cod: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let feelsLike, tempMin, tempMax: Double?
    let pressure, humidity, seaLevel, grndLevel: Double?

//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike
//        case tempMin
//        case tempMax
//        case pressure, humidity
//        case seaLevel
//        case grndLevel
//    }
}

// MARK: - Sys
struct Sys: Codable {
    let country: String?
    let sunrise, sunset: Double?
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main, weatherDescription, icon: String?

//    enum CodingKeys: String, CodingKey {
//        case id, main
//        case weatherDescription
//        case icon
//    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Double?
    let gust: Double?
}

