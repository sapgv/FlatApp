//
//  ViewController.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import UIKit
import CoreData

final class ViewController: UITableViewController {

    var viewModel: ViewModel!
    
    private var fetchController: NSFetchedResultsController<CoreDataMessage>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages"
        self.setupNavigationItems()
        self.setupFetchController()
        self.setupTableView()
        self.performFetch()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.fetchController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchController = fetchController, let sections = fetchController.sections else { return 0 }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else { return UITableViewCell() }
        let message = self.fetchController.object(at: indexPath)
        cell.setup(message: message)
        return cell
    }
    
}

extension ViewController {
    
    private func setupNavigationItems() {
        let startButton = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startAction))
        let stopButton = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(stopAction))
        self.navigationItem.leftBarButtonItem = stopButton
        self.navigationItem.rightBarButtonItem = startButton
    }
    
    private func setupFetchController() {
        let fetchRequest = NSFetchRequest<CoreDataMessage>(entityName: "CoreDataMessage")
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        self.fetchController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchController.delegate = self
    }
    
    private func setupTableView() {
        self.tableView.register(UINib(nibName: "MessageCell", bundle: nibBundle), forCellReuseIdentifier: "MessageCell")
        
    }

    @objc
    private func startAction() {
        self.viewModel.generate()
    }
    
    @objc
    private func stopAction() {
        self.viewModel.stop()
    }
    
    private func performFetch() {
        do {
            try self.fetchController.performFetch()
            self.tableView.reloadData()
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            if let indexPath = indexPath {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            break;
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            tableView.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
}




