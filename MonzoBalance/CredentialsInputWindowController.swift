//
//  CredentialsInputWindow.swift
//  MonzoBalance
//
//  Created by Thomas Horrobin on 29/06/2018.
//  Copyright © 2018 Dylan Buckley. All rights reserved.
//

import Cocoa

class CredentialsInputWindowController: NSWindowController {

    @IBOutlet weak var accountId: NSTextField!
    @IBOutlet weak var accessToken: NSTextField!
    
    @IBAction func addCredentials(_ sender: NSButton) {
        print("hello")
    }
    
    //    @IBAction func addToken(_ sender: Any) {
//        let newCredentials = MonzoCredentials(accountId: accountId.stringValue, accessToken: accessToken.stringValue)
//        self.close()
//    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        NSLog("loaded!")
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
}
