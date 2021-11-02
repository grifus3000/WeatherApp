//
//  CitiesData+CoreDataClass.swift
//  WeatherApp
//
//  Created by Grifus on 01.11.2021.
//
//

import Foundation
import CoreData

@objc(CitiesData)
public class CitiesData: NSManagedObject {
    
    static func object(model: CitiesElement, context: NSManagedObjectContext) {
        let entityDescription = DatabaseManager.shared.getEntityForName("CitiesData")
        let object = CitiesData(entity: entityDescription, insertInto: context)
        object.cityId = Int64(model.id ?? 0)
        object.cityName = model.name
        object.countryName = model.country
    }

}
