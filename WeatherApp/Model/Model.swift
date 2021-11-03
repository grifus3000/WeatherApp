//
//  Model.swift
//  WeatherApp
//
//  Created by Grifus on 20.10.2021.
//

import Foundation

protocol ModelDelegate: AnyObject {
    func setTemperature(city: String, degree: Double)
    func setBackgroundImageBy(name: String)
}

class Model {
    
    weak var delegate: ModelDelegate?
    
    enum urlString: String {
        case moscow = "http://api.openweathermap.org/data/2.5/weather?q=moscow&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
    }
    
    func getWeatherByLocation(completion: @escaping (Data) -> ()) {
        let location = LocationService.shared.getLocation()
        guard let lat = location.lat, let lon = location.lon else { return }
        
        let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        
        getWeather(urlString: urlString) { (imageData) in
            completion(imageData)
        }
    }
    
    func getWeatherBy(cityName: String, completion: @escaping (Data) -> ()) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        
        getWeather(urlString: urlString) { (imageData) in
            completion(imageData)
        }
    }
    
    func getWeatherBy(id: String, completion: @escaping (Data) -> ()) {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?id=\(id)&appid=9d8596d695b3ebb9cfe0e8c2e698037a"
        getWeather(urlString: urlString) { (imageData) in
            completion(imageData)
        }
    }
    
    private func getWeather(urlString: String, completion: @escaping (Data) -> ()) {
        print(urlString)
        InternetService.getWeatherBy(string: urlString) { (weather) in
            self.delegate?.setTemperature(city: weather.name, degree: weather.main.temp)
            self.selectBackgrounImageBy(sunsetTime: weather.sys?.sunset ?? 0.0, sunriseTime: weather.sys?.sunrise ?? 0.0, currentTime: weather.dt ?? 0.0)
            
            guard let iconName = weather.weather?.first?.icon else { return }
            guard let data = InternetService.getIconBy(name: iconName) else { return }
            completion(data)
        }
    }
    
    func selectBackgrounImageBy(sunsetTime: Double, sunriseTime: Double, currentTime: Double) {
        var backgroundName = ""
        if currentTime < sunsetTime && currentTime > sunriseTime {
            backgroundName = "day"
        } else {
            backgroundName = "night"
        }
        self.delegate?.setBackgroundImageBy(name: backgroundName)
    }
    
    func parseCitiesFromJsonToCoreData() {
        let decoder = JSONDecoder()
        let fileUrl = URL(fileURLWithPath: "/Volumes/hdd/Programming/Swift/UIKit/WeatherApp/city.list.json")
        guard let cities = try? decoder.decode(Cities.self, from: Data(contentsOf: fileUrl)) else { return }
        
        cities.forEach { (city) in
            CitiesData.object(model: city, context: DatabaseManager.shared.persistentContainer.viewContext)
        }
        DatabaseManager.shared.saveContext()
    }
    
    func addCitiesInCoreData() {
        
    }
    
}
