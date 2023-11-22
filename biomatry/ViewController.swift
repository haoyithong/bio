//
//  ViewController.swift
//  biomatry
//
//  Created by Haoyi Thong on 22/11/2023.
//

import Security

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var functionTimeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    let username = "john"
    let password = "1234".data(using: .utf8)!
  
    
    static func getBioSecAccessControl() -> SecAccessControl {
        var error: Unmanaged<CFError>?
        let access: SecAccessControl? = SecAccessControlCreateWithFlags(nil,
                                                                    kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
                                                                    .biometryCurrentSet,
                                                                    &error)

        precondition(access != nil, "SecAccessControlCreateWithFlags failed")
        return access!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }

    func currentTimeStr() -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    @IBAction func saveData() {
        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessControl as String: ViewController.getBioSecAccessControl(),
            kSecAttrAccount as String: username,
            kSecValueData as String: password,
        ]
        // Add user
        if SecItemAdd(attributes as CFDictionary, nil) == noErr {
            self.functionTimeLabel.text = currentTimeStr()
            self.valueLabel.text = "Save success"
            print("User saved successfully in the keychain")
        } else {
            self.functionTimeLabel.text = currentTimeStr()
            self.valueLabel.text = "Save fail"
            print("Something went wrong trying to save the user in the keychain")
        }
    }
    
    @IBAction func loadData() {
        let username = "john"
        // Set query
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccessControl as String: ViewController.getBioSecAccessControl(),
            kSecAttrAccount as String: username,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true,
        ]
        var item: CFTypeRef?
        // Check if user exists in the keychain
   
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            // Extract result
            if let existingItem = item as? [String: Any],
               let username = existingItem[kSecAttrAccount as String] as? String,
               let passwordData = existingItem[kSecValueData as String] as? Data,
               let password = String(data: passwordData, encoding: .utf8)
            {
                
                self.functionTimeLabel.text = currentTimeStr()
                self.valueLabel.text = "load  success\nvalue: \(password)"
                
                print(username)
                print(password)
            }
        } else {
            self.functionTimeLabel.text = currentTimeStr()
            self.valueLabel.text = "Something went wrong trying to find the user in the keychain"
            print("Something went wrong trying to find the user in the keychain")
        }
    }
}

