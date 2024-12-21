//
//  FlatAppTests.swift
//  FlatAppTests
//
//  Created by Grigory Sapogov on 21.12.2024.
//

import XCTest
import CoreData
@testable import FlatApp

final class CDChatRoomTests: XCTestCase {

    var sut: CDChatRoomStorage!
    
    var privateContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        let privateContext = CoreDataStack.shared.createChildContext(.privateQueueConcurrencyType)
        self.privateContext = privateContext
        self.sut = CDChatRoomStorage(privateContext: privateContext)
    }
    
    override func tearDown() {
        super.tearDown()
        self.sut = nil
        self.privateContext = nil
    }
    
    func testCreateSerial() {
        
        let mxRoom = self.createMxRoom()
        
        let cdRoomsInCoreDataBeforeSave = CDChatRoom.findAll(id: mxRoom.id, context: self.privateContext)
        
        XCTAssertEqual(cdRoomsInCoreDataBeforeSave.count, 0)
        
        let exp = expectation(description: "saveChatRoom")
        
        let group = DispatchGroup()
        
        for _ in 1...1000 {
            group.enter()
        }
        
        self.networkCallImitation {
            
            sut.saveChatRoomSerial(mxRoom: mxRoom) { _ in
                
                group.leave()
                
            }
            
        }
        
        group.notify(queue: .main) {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3)
        
        let cdRoomsInCoreDataAfterSave = CDChatRoom.findAll(id: mxRoom.id, context: self.privateContext)
        
        XCTAssertEqual(cdRoomsInCoreDataAfterSave.count, 1)
        
        let cdChatRoomAfterSave = CDChatRoom.findExisted(id: mxRoom.id, context: self.privateContext)
        XCTAssertEqual(cdChatRoomAfterSave?.id, mxRoom.id)
        XCTAssertEqual(cdChatRoomAfterSave?.message, mxRoom.message)
        
    }
    
    func testCreateConcurrent() {
        
        let mxRoom = self.createMxRoom()
        
        let cdRoomsInCoreDataBeforeSave = CDChatRoom.findAll(id: mxRoom.id, context: self.privateContext)
        
        XCTAssertEqual(cdRoomsInCoreDataBeforeSave.count, 0)
        
        let exp = expectation(description: "saveChatRoom")
        
        let group = DispatchGroup()
        
        for _ in 1...1000 {
            group.enter()
        }
        
        self.networkCallImitation {
            
            sut.saveChatRoomConcurrent(mxRoom: mxRoom) { _ in
                
                group.leave()
                
            }
            
        }
        
        sut.saveChatRoomSerial(mxRoom: mxRoom) { _ in
            
            exp.fulfill()
            
        }
        
        wait(for: [exp], timeout: 3)
        
        let cdRoomsInCoreDataAfterSave = CDChatRoom.findAll(id: mxRoom.id, context: self.privateContext)
        
        XCTAssertEqual(cdRoomsInCoreDataAfterSave.count, 1)
        
    }

}

extension CDChatRoomTests {
    
    func networkCallImitation(completion: () -> Void) {
        
        DispatchQueue.concurrentPerform(iterations: 1000) { _ in
            
            completion()
            
        }
        
    }
    
    func createMxRoom() -> MXRoom {
        let mxRoom = MXRoom(id: UUID().uuidString, message: "Test MX Room")
        return mxRoom
    }
    
}
