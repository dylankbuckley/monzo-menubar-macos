//
//  CredentialsInputWindow.swift
//  MonzoBalance
//
//  Created by Thomas Horrobin on 01/07/2018.
//  Copyright © 2018 Dylan Buckley. All rights reserved.
//

import Cocoa

class CredentialsInputWindow: NSViewController {
    
    @IBOutlet weak var accountIdTextbox: NSTextField!
    @IBOutlet weak var accessTokenTextbox: NSTextField!
    
    let appDelegate = NSApplication.shared.delegate as! AppDelegate
    
    @IBAction func updateCredentials(_ sender: Any) {
        let newCredentials = MonzoCredentials(accountId: accountIdTextbox.stringValue, accessToken: accessTokenTextbox.stringValue)
        appDelegate.setCredentials(newCredentials: newCredentials)
        self.view.window?.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if appDelegate.credentials.accountId != "" {
            self.accountIdTextbox.stringValue = appDelegate.credentials.accountId
            self.accessTokenTextbox.stringValue = appDelegate.credentials.accessToken
        }
    }
    
}
