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
    
    @IBAction func updateCredentials(_ sender: Any) {
        let newCredentials = MonzoCredentials(accountId: accountIdTextbox.stringValue, accessToken: accessTokenTextbox.stringValue)
        let appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.setCredentials(credentials: newCredentials)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
