//
//  Model.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import Foundation

protocol ModelDelegate: AnyObject {
    func setTemperature(city: String, degree: Double)
}

class Model {
    
    weak var delegate: ModelDelegate?
    
    enum urlString: String {
        case moscow = "http://api.openweathermap.org/data/2.5/weather?q=moscow&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
    }
    
    func getWeatherByLocation() {
        let location = LocationService.shared.getLocation()
        guard let lat = location.lat, let lon = location.lon else { return }
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        
        getWeather(urlString: urlString)
    }
    
    func getWeatherBy(cityName: String) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        getWeather(urlString: urlString)
    }
    
    func getWeatherBy(id: String) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        getWeather(urlString: urlString)
    }
    
    private func getWeather(urlString: String) {
        print(urlString)
        InternetService.getWeatherBy(string: urlString) { (weather) in
            self.delegate?.setTemperature(city: weather.name, degree: weather.main.temp)
        }
    }
    
    func parseCitiesFromJsonToCoreData() {
        let decoder = JSONDecoder()
        let fileUrl = URL(fileURLWithPath: "/Volumes/hdd/Programming/Swift/UIKit/WeatherApp/city.list.json")
        guard let cities = try? decoder.decode(Cities.self, from: Data(contentsOf: fileUrl)) else { return }
        
        cities.forEach { (city) in
//            citiesDict[city.name ?? ""] = city.id
            CitiesData.object(model: city, context: DatabaseManager.shared.persistentContainer.viewContext)
        }
        DatabaseManager.shared.saveContext()
    }
    
    func addCitiesInCoreData() {
        
    }
    
}
