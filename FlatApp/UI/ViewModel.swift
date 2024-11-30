//
//  ViewModel.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import Foundation

class ViewModel {
    
    private var generators: [MessageGenerator] = []
    
    init(generators: [MessageGenerator] = ViewModel.defaultGenerators()) {
        self.generators = generators
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
        
        
        
    }
    
}

extension ViewModel {
    
    static func defaultGenerators() -> [MessageGenerator] {
        return (1...1).map { _ in
            MessageGenerator()
        }
    }
    
}

extension ViewModel: MessageGeneratorDelegate {
    
    func didGenerated(_ message: Message) {
        
        print("App Delegate didGenerated \(message) Date \(Date())")
        
        //save in Core Data
        
    }
    
}
