//
//  ViewController.swift
//  SayMyName
//
//  Created by Pau Escalante on 7/22/19.
//  Copyright © 2019 Hackathon. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    var speechController: Recordable!
    
    @IBOutlet var ListenButton: UIButton!
    
    @IBOutlet var WordHistoryTable: UITableView!
    
    @IBOutlet var WordRecognizedLabel: UILabel!
    
    var IsListening : Bool = false
    var dismissHandler: ((Bool) -> ())? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    func allowMicrophoneTapped() {
        print("Tap")
        speechController.requestAuthorization { _ in
            AVAudioSession.sharedInstance().requestRecordPermission({ (isGranted) in
                self.dismissMe(animated: true) {
                    print("dismiss")
                }
            })
        }
    }
    
    func SetupApplication(){
        IsListening = false
        ListenButton.setTitle("Listen", for: .normal)
    }

    @IBAction func ListenButtonPress(_ sender: UIButton) {
        allowMicrophoneTapped()
        IsListening = !IsListening
        ListenButton.setTitle(IsListening ? "Stop" : "Listen", for: .normal)
        
    }
    
}

