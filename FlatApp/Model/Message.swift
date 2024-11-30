//
//  Message.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import Foundation

struct Message {
    
    let id: Int
    
    let roomId: Int
    
    let date: Date
    
    let text: String
    
    init(
        id: Int,
        roomId: Int,
        date: Date
    ) {
        self.id = id
        self.roomId = roomId
        self.date = date
        self.text = "\(id)"
    }
    
}
