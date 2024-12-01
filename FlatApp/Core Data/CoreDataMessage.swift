//
//  CoreDataMessage.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 01.12.2024.
//

import Foundation

extension CoreDataMessage {
    
    func fill(message: Message) {
        self.id = Int64(message.id)
        self.roomId = Int64(message.roomId)
        self.date = message.date
        self.text = message.text
    }
    
}
