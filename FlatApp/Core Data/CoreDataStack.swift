//
//  CoreDataStack.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 30.11.2024.
//

import CoreData

final class CoreDataStack {
    
    private let container: NSPersistentContainer
    
    private(set) var viewContext: NSManagedObjectContext!
    
    static let shared: CoreDataStack = CoreDataStack()
    
    private init() {
        
        self.container = NSPersistentContainer(name: "FlatApp")
        
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            print(storeDescription)
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            self.viewContext = self.container.viewContext
            self.viewContext.automaticallyMergesChangesFromParent = true
            
        })
        
    }
    
    func createChildContext(_ concurrencyType: NSManagedObjectContextConcurrencyType) -> NSManagedObjectContext {
        
        let privateContext = NSManagedObjectContext(concurrencyType: concurrencyType)
        privateContext.persistentStoreCoordinator = self.container.persistentStoreCoordinator

        return privateContext
        
    }
    
    func save(context: NSManagedObjectContext, completion: ((SaveResult) -> Void)? = nil) {
        
        guard context.hasChanges else {
            DispatchQueue.main.async {
                completion?(.hasNoChanges)
            }
            return
        }
        
        do {
            try context.save()
            DispatchQueue.main.async {
                completion?(.success)
            }
        }
        catch let error {
            print(error)
            DispatchQueue.main.async {
                completion?(.failure)
            }
        }
        
    }
    
}

extension CoreDataStack {
    
    enum SaveResult {
        case success
        case hasNoChanges
        case failure
    }
    
}
