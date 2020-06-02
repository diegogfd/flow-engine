//
//  ViewController.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 04/13/2020.
//  Copyright (c) 2020 Diego Flores Domenech. All rights reserved.
//

import UIKit
import FlowEngine

class ExampleViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let numberOfExamples = 2
    private var flowEngine = FlowEngine()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let navigationController = navigationController {
            flowEngine.registerActions([
                SimpleCalculatorAction(navigationController: navigationController),
                DescriptionDialogAction(navigationController: navigationController),
                CardTypeRandomAction(),
                SimpleCongratsAction(navigationController: navigationController),
                DescriptionCalculatorAction(navigationController: navigationController),
                InstallmentsSelectionAction(navigationController: navigationController)
            ])
        }
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

extension ExampleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfExamples
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Example \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        flowEngine.fetch(actionsFileName: "actions_\(indexPath.row + 1)")
        flowEngine.goNext()
    }
    
}

