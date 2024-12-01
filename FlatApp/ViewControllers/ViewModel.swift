//
//  ViewModel.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import Foundation

class ViewModel {
    
    private var generators: [MessageGenerator] = []
    
    private var messageStorage: MessageStorage
    
    var messageSaveCompletion: ((Error?) -> Void)? = nil
    
    init(
        generators: [MessageGenerator] = ViewModel.defaultGenerators(),
        messageStorage: MessageStorage = MessageStorage()
    ) {
        self.generators = generators
        self.messageStorage = messageStorage
        self.setup()
    }
    
    func setup() {
        
        for generator in self.generators {
            generator.delegate = self
        }
        
    }
    
    func generate() {
        
        for generator in self.generators {
            generator.generate()
        }
        
    }
    
    func stop() {
        
        for generator in self.generators {
            generator.stop()
        }
        
    }
    
}

extension ViewModel {
    
    static func defaultGenerators() -> [MessageGenerator] {
        return (1...10).map { _ in
            MessageGenerator()
        }
    }
    
}

extension ViewModel: MessageGeneratorDelegate {
    
    func didGenerated(_ message: Message) {
        
        print("Delegate didGenerated \(message) Date \(Date())")
        
        self.messageStorage.save(message: message) { error in
            
            self.messageSaveCompletion?(error)
            
        }
        
    }
    
}
