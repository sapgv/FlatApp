//
//  CDChatRoomStorage.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 21.12.2024.
//

import CoreData

class CDChatRoomStorage {
    
    private let privateContext: NSManagedObjectContext
    
    init(privateContext: NSManagedObjectContext = CoreDataStack.shared.createChildContext(.privateQueueConcurrencyType)) {
        self.privateContext = privateContext
    }
    
    func saveChatRoomSerial(mxRoom: MXRoom, completion: @escaping (CDChatRoom) -> Void) {
        
        self.privateContext.perform { [privateContext] in
            
            if let existed = CDChatRoom.findExisted(id: mxRoom.id, context: privateContext) {
                completion(existed)
                return
            }
            
            let newCDChatRoom = CDChatRoom(context: privateContext)
            
            newCDChatRoom.fill(mxRoom: mxRoom)
            
            CoreDataStack.shared.save(context: privateContext) { _ in
                
                DispatchQueue.main.async {
                    
                    let newCDChatRoom = CoreDataStack.shared.viewContext.object(with: newCDChatRoom.objectID) as! CDChatRoom
                    
                    completion(newCDChatRoom)
                    
                }
                
            }
            
        }
        
    }
    
    func saveChatRoomConcurrent(mxRoom: MXRoom, completion: @escaping (CDChatRoom) -> Void) {
        
        let privateContext = CoreDataStack.shared.createChildContext(.privateQueueConcurrencyType)
        
        privateContext.perform { [privateContext] in
            
            if let existed = CDChatRoom.findExisted(id: mxRoom.id, context: privateContext) {
                completion(existed)
                return
            }
            
            let newCDChatRoom = CDChatRoom(context: privateContext)
            
            newCDChatRoom.fill(mxRoom: mxRoom)
            
            CoreDataStack.shared.save(context: privateContext) { _ in
                
                DispatchQueue.main.async {
                    
                    let newCDChatRoom = CoreDataStack.shared.viewContext.object(with: newCDChatRoom.objectID) as! CDChatRoom
                    
                    completion(newCDChatRoom)
                    
                }
                
            }
            
        }
        
    }
    
}

public 
extension CDChatRoom {
    
    func fill(mxRoom: MXRoom) {
        
        self.id = mxRoom.id
        self.message = mxRoom.message
        
    }
    
    static func findExisted(id: String, context: NSManagedObjectContext) -> CDChatRoom? {
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        let cdChatRoom = CoreDataStack.shared.fetchOne(type: CDChatRoom.self, predicate: predicate, context: context)
        
        return cdChatRoom
        
    }
    
    static func findAll(id: String, context: NSManagedObjectContext) -> [CDChatRoom] {
        
        let predicate = NSPredicate(format: "id == %@", id)
        
        let cdChatRooms = CoreDataStack.shared.fetchAll(type: CDChatRoom.self, predicate: predicate, context: context)
        
        return cdChatRooms
        
    }
    
    
}
