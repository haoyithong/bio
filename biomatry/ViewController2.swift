//
//  ViewController2.swift
//  biomatry
//
//  Created by Haoyi Thong on 22/11/2023.
//

import UIKit
import LocalAuthentication

class ViewController2: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    let username = "john"
    let password = "1234".data(using: .utf8)!
    let preferences = UserDefaults.standard
    
    func saveUserDefault(oldDomainState: Data) {
        preferences.setValue(oldDomainState, forKey: "oldDomainState")
    }
    
    func getUserDefault() -> Data? {
        return preferences.value(forKey: "oldDomainState") as? Data
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resetBio() {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        if let domainState = context.evaluatedPolicyDomainState {
            self.saveUserDefault(oldDomainState: domainState)
            label1.text = "reset success"
        }
        
    }
    
    @IBAction func checkStatus() {
        let context = LAContext()
        context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        let oldDomainState = getUserDefault()
        if let domainState = context.evaluatedPolicyDomainState, domainState == oldDomainState {
            label2.text = "same"
        } else {
            label2.text = "diff"
        }
    }
}
