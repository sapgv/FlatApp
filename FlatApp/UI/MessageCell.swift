//
//  MessageCell.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 30.11.2024.
//

import UIKit
import CoreData

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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(didSaveCoreDataMessage), name: .didSaveCoreDataMessage, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setup(message: CoreDataMessage) {
        self.message = message
        self.idLabel.text = "\(message.id)"
        self.roomIdLabel.text = "\(message.roomId)"
        self.dateLabel.text = message.date?.text
        self.messageLabel.text = "Some message text \(message.text ?? "")"
    }
    
}

extension MessageCell {
    
    @objc
    private func didSaveCoreDataMessage(notification: Notification) {
        guard let objectId = notification.object as? NSManagedObjectID else { return }
        guard self.message?.objectID == objectId else { return }
        self.animateBackgroundColor()
    }
    
    private func animateBackgroundColor() {
        UIView.animate(withDuration: 0.5, animations: {
            self.contentView.backgroundColor = .green.withAlphaComponent(0.3)
        }) { _ in
            UIView.animate(withDuration: 0.5) {
                self.contentView.backgroundColor = .white
            }
        }
    }
    
}
