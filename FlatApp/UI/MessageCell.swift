//
//  MessageCell.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 30.11.2024.
//

import UIKit

final class MessageCell: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var roomIdLabel: UILabel!
    
    private var message: CoreDataMessage?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.message = nil
    }
    
    func setup(message: CoreDataMessage) {
        self.message = message
        self.idLabel.text = "\(message.id)"
        self.roomIdLabel.text = "\(message.roomId)"
        self.dateLabel.text = message.date?.text
        self.messageLabel.text = "Some message text \(message.text ?? "")"
        self.animateBackgroundColor(message: message)
    }
    
}

extension MessageCell {
    
    private func animateBackgroundColor(message: CoreDataMessage) {
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.backgroundColor = .green.withAlphaComponent(0.1)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.contentView.backgroundColor = .white
            }
        }
    }
    
}
