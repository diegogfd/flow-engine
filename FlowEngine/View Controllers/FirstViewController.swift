//
//  FirstViewController.swift
//  FlowEngine
//
//  Created by Diego Flores Domenech on 4/1/20.
//  Copyright © 2020 Diego Flores. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, ActionAssociated {
    var action: Action
    
    init(action: Action) {
        self.action = action
        super.init(nibName: "FirstViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "First View Controller"
    }
    
    @IBAction func didTapButton() {

    }

}
