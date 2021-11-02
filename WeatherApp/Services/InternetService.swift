//
//  InternetService.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import Foundation

class InternetService {
    
    static let decoder = JSONDecoder()
    
    static func getWeatherBy(string urlString: String, completion: @escaping (WeatherData) -> ()) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, respond, error) in
            if let error = error { print("ERROR:: \(error)") }
            
            guard let data = data else { return }

            guard let weather = try? decoder.decode(WeatherData.self, from: data) else { return }
            
            
            completion(weather)
        }.resume()
    }
}
