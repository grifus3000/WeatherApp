//
//  CitiesData+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Grifus on 01.11.2021.
//
//

import Foundation
import CoreData


extension CitiesData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CitiesData> {
        return NSFetchRequest<CitiesData>(entityName: "CitiesData")
    }

    @NSManaged public var cityName: String?
    @NSManaged public var countryName: String?
    @NSManaged public var cityId: Int64

}

extension CitiesData : Identifiable {

}
