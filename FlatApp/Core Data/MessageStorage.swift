//
//  MessageStorage.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 30.11.2024.
//

import CoreData

final class MessageStorage {

    private let privateContext: NSManagedObjectContext
    
    private var data: [Int: NSManagedObjectID] = [:]
    
    init(privateContext: NSManagedObjectContext = CoreDataStack.shared.createChildContext(.privateQueueConcurrencyType)) {
        self.privateContext = privateContext
    }
    
    func save(message: Message, completion: @escaping (Errors?) -> Void) {
        
        self.privateContext.perform {
            
            let coreDataMessage = self.createMessage(message: message, context: self.privateContext)
            
            if message.date > (coreDataMessage.date ?? .distantPast) {
                coreDataMessage.fill(message: message)
            }
            
            CoreDataStack.shared.save(context: self.privateContext) { result in
                
                switch result {
                case .success, .hasNoChanges:
                    self.privateContext.refresh(coreDataMessage, mergeChanges: true)
                    self.privateContext.perform {
                        self.data[message.id] = coreDataMessage.objectID
                    }
                    completion(nil)
                case .failure:
                    completion(.saveFailure("CoreDataMessage"))
                }
                
            }
            
        }
        
    }
    
}

extension MessageStorage {
    
    enum Errors: Error {
        case saveFailure(_ entityName: String)
    }
    
    func createMessage(message: Message, context: NSManagedObjectContext) -> CoreDataMessage {
        
        if let objectID = self.data[message.id], let coreDataMessage = context.object(with: objectID) as? CoreDataMessage {
            return coreDataMessage
        }

        if let coreDataMessage = self.fetchMessage(id: message.id, context: context) {
            return coreDataMessage
        }
        
        let coreDataMessage = CoreDataMessage(context: context)
        
        return coreDataMessage
        
    }
    
    func fetchMessage(id: Int, context: NSManagedObjectContext) -> CoreDataMessage? {
        
        let request = NSFetchRequest<CoreDataMessage>(entityName: "CoreDataMessage")
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", id)
        
        do {
            let results = try context.fetch(request)
            return results.first
        }
        catch {
            return nil
        }
        
    }
    
}
