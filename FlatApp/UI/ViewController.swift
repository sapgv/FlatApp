//
//  ViewController.swift
//  FlatApp
//
//  Created by Grigory Sapogov on 27.11.2024.
//

import UIKit

final class ViewController: UITableViewController {

    var viewModel: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Messages"
        self.setupNavigationItems()
    }
    
}

extension ViewController {
    
    private func setupNavigationItems() {
        let startButton = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startAction))
        let stopButton = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(stopAction))
        self.navigationItem.leftBarButtonItem = stopButton
        self.navigationItem.rightBarButtonItem = startButton
    }

    @objc
    private func startAction() {
        self.viewModel.generate()
    }
    
    @objc
    private func stopAction() {
        self.viewModel.stop()
    }
    
}
