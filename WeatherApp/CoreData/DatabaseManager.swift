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
    
    func getFetchResultController(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let filter = filterKey {
            fetchRequest.predicate = NSPredicate(format: "character.id = %@", filter)
        }
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func getFetchRequestControllerObject(entityName: String, sortDescriptorKey: String, filterKey: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: sortDescriptorKey, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let filter = filterKey {
            fetchRequest.predicate = NSPredicate(format: "id = %@", filter)
        }
        
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
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
