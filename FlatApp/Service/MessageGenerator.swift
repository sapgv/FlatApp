//
//  MessageGenerator.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import Foundation

protocol MessageGeneratorDelegate: AnyObject {
    
    func didGenerated(_ message: Message)

}

final class MessageGenerator {
    
    weak var delegate: MessageGeneratorDelegate?
    
    private var timeInterval: TimeInterval = Double(Int.random(in: 1...5)) {
        didSet {
            print("NEW TIME INTERVAL \(timeInterval)")
        }
    }
    
    private let queue = DispatchQueue(label: "MessageGenerator.Queue.\(UUID().uuidString)")
    
    private lazy var date_: Date = Date()
    private var date: Date {
        get {
            return date_
        }
        set {
            self.date_ = newValue
        }
    }
    
    private var timer: Timer?
    
    func generate() {
        
        self.fire()
        
    }
    
    func cancel() {
        
        self.timer?.invalidate()
        
    }
    
}

extension MessageGenerator {
    
    private func fire() {
        
        print("======================================================")
        print("")
        print("Fire in \(self.timeInterval) seconds. CurrentDate \(Date())")
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeInterval) {
//            self.fireAction()
//        }
        
        
        
        
        
    }
    
    @objc
    private func fireAction() {
        
        print("")
        print("Did fire CurrentDate \(Date())")
        
        self.queue.async { [weak self] in
            
            guard let self = self else { return }
                
            let message = Message(id: Int.random(in: 0...1000), roomId: Int.random(in: 0...4), date: self.date)
            
            DispatchQueue.main.async {
            
                print("Did generate Message. CurrentDate \(Date())")
                
                print("\(message)")
                
                print("")
                
                print("======================================================")
                
                self.delegate?.didGenerated(message)
                
                self.restart()
                
            }
            
        }
        
    }
    
    private func restart() {
        self.date.addTimeInterval(1)
        self.timeInterval = Double(Int.random(in: 1...5))
        self.fire()
    }
    
}
