//
//  DatabaseManager.swift
//  WeatherApp
//
//  Created by Grifus on 31.10.2021.
//

import Foundation
import CoreData

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func getEntityForName(_ string: String) -> NSEntityDescription {
        return NSEntityDescription.entity(forEntityName: string, in: persistentContainer.viewContext)!
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CitiesData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
