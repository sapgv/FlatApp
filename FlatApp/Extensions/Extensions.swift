//
//  Extensions.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 30.11.2024.
//

import Foundation

extension Date {
    
    var text: String {
        dateFormatter.string(from: self)
    }
    
}

extension Optional where Wrapped == Date {
    
    var text: String {
        guard let self = self else { return "" }
        return self.text
    }
    
}

var dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "ru")
    return dateFormatter
}()

extension Notification.Name {
    
    static let didSaveCoreDataMessage = Notification.Name("didSaveCoreDataMessage")
    
}
