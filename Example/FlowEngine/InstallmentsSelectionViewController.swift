//
//  InstallmentsSelectionViewController.swift
//  FlowEngine_Example
//
//  Created by Diego Flores Domenech on 5/25/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import FlowEngine
import MLCommons

class InstallmentsSelectionViewController: MLBaseViewController, FlowEngineComponent {
    
    private let installments = [1,3,6,9,12,18]
    
    @IBOutlet private var tableView: UITableView!
    
    var flowEngine: FlowEngine!
    
    init(flowEngine: FlowEngine) {
        self.flowEngine = flowEngine
        super.init(nibName: "InstallmentsSelectionViewController", bundle: nil)
        self.addBehaviour(FlowEngineBehaviour(flowEngine: flowEngine))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

extension InstallmentsSelectionViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.installments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "\(self.installments[indexPath.row])x"
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.flowEngine.updateFlowState(fieldId: .installments, value: self.installments[indexPath.row])
        self.flowEngine.goNext()
    }
    
    
}
