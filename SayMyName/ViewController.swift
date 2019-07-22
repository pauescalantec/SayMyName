//
//  ViewController.swift
//  SayMyName
//
//  Created by Pau Escalante on 7/22/19.
//  Copyright © 2019 Hackathon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ListenButton: UIButton!
    
    @IBOutlet var WordHistoryTable: UITableView!
    
    @IBOutlet var WordRecognizedLabel: UILabel!
    
    var IsListening : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func SetupApplication(){
        IsListening = false
        ListenButton.setTitle("Listen", for: .normal)
    }

    @IBAction func ListenButtonPress(_ sender: UIButton) {
        IsListening = !IsListening
        ListenButton.setTitle(IsListening ? "Stop" : "Listen", for: .normal)
        
    }
    
}

