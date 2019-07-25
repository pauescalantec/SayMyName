//
//  ViewController.swift
//  VoiceOverlay-Demo
//
//  Created by Guy Daher on 25/06/2018.
//  Copyright © 2018 Algolia. All rights reserved.
//

import UIKit
import InstantSearchVoiceOverlay
import Foundation
import UserNotifications
import WatchConnectivity

class ViewController: UIViewController, VoiceOverlayDelegate, WCSessionDelegate {

  let voiceOverlayController = VoiceOverlayController()
  let button = UIButton()
  let buttonAddWord = UIButton()
  let buttonWords = UIButton()
  let label = UILabel()
  var searchableWords : Array = ["chris","rachel","danger","fire"]
  var lastIndexSearched : Int = 0
  var lastMessage: CFAbsoluteTime = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    UNUserNotificationCenter.current().delegate = self
    
    let margins = view.layoutMarginsGuide
    
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    buttonAddWord.addTarget(self, action: #selector(addWord), for: .touchUpInside)
    buttonWords.addTarget(self, action: #selector(viewWords), for: .touchUpInside)

    label.text = "Result Text from the Voice Input"
    
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 0
    label.textAlignment = .center
    
    button.setTitle("Start using voice", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.backgroundColor = UIColor(red: 255/255.0, green: 64/255.0, blue: 129/255.0, alpha: 1)
    button.layer.cornerRadius = 7
    button.layer.borderWidth = 1
    button.layer.borderColor = UIColor(red: 237/255, green: 82/255, blue: 129/255, alpha: 1).cgColor
    
    buttonAddWord.setTitle("Add Word", for: .normal)
    buttonAddWord.setTitleColor(.white, for: .normal)
    buttonAddWord.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    buttonAddWord.backgroundColor = UIColor(red: 0/255.0, green: 128/255.0, blue: 0/255.0, alpha: 1)
    buttonAddWord.layer.cornerRadius = 7
    buttonAddWord.layer.borderWidth = 1
    buttonAddWord.layer.borderColor = UIColor(red: 0/255, green: 128/255, blue: 0/255, alpha: 1).cgColor
    
    buttonWords.setTitle("View Words", for: .normal)
    buttonWords.setTitleColor(.white, for: .normal)
    buttonWords.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    buttonWords.backgroundColor = UIColor(red: 255/255.0, green: 140/255.0, blue: 0/255.0, alpha: 1)
    buttonWords.layer.cornerRadius = 7
    buttonWords.layer.borderWidth = 1
    buttonWords.layer.borderColor = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 1).cgColor
    
    label.translatesAutoresizingMaskIntoConstraints = false
    button.translatesAutoresizingMaskIntoConstraints = false
    buttonAddWord.translatesAutoresizingMaskIntoConstraints = false
    buttonWords.translatesAutoresizingMaskIntoConstraints = false
    
    self.view.addSubview(label)
    self.view.addSubview(button)
    self.view.addSubview(buttonAddWord)
    self.view.addSubview(buttonWords)
    
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
      label.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
      label.topAnchor.constraint(equalTo: margins.topAnchor, constant: 110),
      ])
    
    NSLayoutConstraint.activate([
    button.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
    button.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
    button.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 10),
    button.heightAnchor.constraint(equalToConstant: 50),
    ])
    
    NSLayoutConstraint.activate([
    buttonAddWord.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
    buttonAddWord.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
    buttonAddWord.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 80),
    buttonAddWord.heightAnchor.constraint(equalToConstant: 50),
    ])
    
    NSLayoutConstraint.activate([
    buttonWords.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
    buttonWords.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
    buttonWords.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: 150),
    buttonWords.heightAnchor.constraint(equalToConstant: 50),
    ])
    
    voiceOverlayController.delegate = self
    
    // If you want to start recording as soon as modal view pops up, change to true
    voiceOverlayController.settings.autoStart = true
    voiceOverlayController.settings.autoStop = false
    voiceOverlayController.settings.showResultScreen = false
    voiceOverlayController.settings.layout.inputScreen.subtitleBulletList = ["Fire", "Danger"]
    
    if (WCSession.isSupported()) {
        let session = WCSession.default
        session.delegate = self
        session.activate()
    }
}
    
    func sendNotification(wordFound: String){
        let wordContent = UNMutableNotificationContent()
        wordContent.title = wordFound
        wordContent.subtitle = "Heard"
        
        let wordTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.2, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Heard word \(wordFound)", content: wordContent, trigger: wordTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
    }

    
    func parseInputText(inputText : String) {
        let inputTextArray = inputText.components(separatedBy: " ")
        
        if (lastIndexSearched >= inputTextArray.count)
        {
            lastIndexSearched = inputTextArray.count - 1
        }
        
        //for (index, inputWord) in inputTextArray.enumerated()
        for index in lastIndexSearched..<inputTextArray.count {
            
            let isFound = searchableWords.contains(inputTextArray[index].lowercased())
            
            if (isFound)
            {
                sendNotification(wordFound: inputTextArray[index])
                sendWatchMessage(text: inputTextArray[index])
            }
            print("\(inputTextArray[index])")
            print("Found \(isFound)")
            lastIndexSearched += 1
        }
    }
  
    @objc func buttonTapped() {
    // First way to listen to recording through callbacks
    voiceOverlayController.start(on: self, textHandler: { (text, final, extraInfo) in
      //print("callback: getting \(String(describing: text))")
      //print("callback: is it final? \(String(describing: final))")
        
      self.parseInputText(inputText: text)
      
      if final {
        // here can process the result to post in a result screen
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
          let myString = text
          let myAttribute = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
          let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
          
           print("WORD \(myString)")
            
          self.voiceOverlayController.settings.resultScreenText = myAttrString
          self.voiceOverlayController.settings.layout.resultScreen.titleProcessed = "BLA BLA"
        })
      }
    }, errorHandler: { (error) in
      print("callback: error \(String(describing: error))")
    }, resultScreenHandler: { (text) in
      print("Result Screen: \(text)")
    }
    )
  }
    
    @objc func addWord() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Word", message: "Enter a single word to recognize", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "danger"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            let wordToAdd = textField?.text?.lowercased()
            if (wordToAdd != ""){
               self.searchableWords.append(wordToAdd!)
            }
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func viewWords() {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Recognize Words:", message: searchableWords.joined(separator: ", "), preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        //alert.addTextField { (textField) in
          //  textField.placeholder = "danger"
        //}
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
  // Second way to listen to recording through delegate
  func recording(text: String?, final: Bool?, error: Error?) {
    if let error = error {
      print("delegate: error \(error)")
    }
    
    if error == nil {
      label.text = text
    }
  }
  
    func sendWatchMessage(text: String) {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        // send a message to the watch if it's reachable
        //if (WCSession.default.isReachable) {
            // this is a meaningless message, but it's enough for our purposes
            let message = ["Message": (text)]
            WCSession.default.sendMessage(message, replyHandler: nil)
        //}
        
        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
}
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        // some other way of handling notification
        completionHandler([.alert, .sound])
    }
}
