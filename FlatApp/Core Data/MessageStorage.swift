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
        
        self.privateContext.perform { [privateContext] in
            
            let coreDataMessage = self.createMessage(message: message, context: self.privateContext)
            
            if message.date > (coreDataMessage.date ?? .distantPast) {
                coreDataMessage.fill(message: message)
            }
            
            CoreDataStack.shared.save(context: privateContext) { result in
                
                privateContext.refresh(coreDataMessage, mergeChanges: false)
                
                switch result {
                case .success, .hasNoChanges:
                    self.sendSaveNotification(coreDataMessage: coreDataMessage)
                    self.updateMessageData(coreDataMessage: coreDataMessage)
                    completion(nil)
                case .failure:
                    completion(.saveFailure("CoreDataMessage"))
                }
                
            }
            
        }
        
    }
    
}

extension MessageStorage {
    
    private func createMessage(message: Message, context: NSManagedObjectContext) -> CoreDataMessage {
        
        if let objectID = self.data[message.id], let coreDataMessage = context.object(with: objectID) as? CoreDataMessage {
            return coreDataMessage
        }

        if let coreDataMessage = self.fetchMessage(id: message.id, context: context) {
            return coreDataMessage
        }
        
        let coreDataMessage = CoreDataMessage(context: context)
        
        return coreDataMessage
        
    }
    
    private func fetchMessage(id: Int, context: NSManagedObjectContext) -> CoreDataMessage? {
        
        let predicate = NSPredicate(format: "id == %i", id)
        
        return CoreDataStack.shared.fetchOne(type: CoreDataMessage.self, predicate: predicate, context: context)
        
    }
    
    private func updateMessageData(coreDataMessage: CoreDataMessage) {
        
        self.privateContext.perform {
            let id = Int(coreDataMessage.id)
            self.data[id] = coreDataMessage.objectID
        }
        
    }
    
    private func sendSaveNotification(coreDataMessage: CoreDataMessage) {
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didSaveCoreDataMessage, object: coreDataMessage.objectID)
        }
    }
    
}

extension MessageStorage {
    
    enum Errors: Error {
        case saveFailure(_ entityName: String)
    }
    
}
