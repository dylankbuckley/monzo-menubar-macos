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

extension NSTextField {
    override open func performKeyEquivalent(with event: NSEvent) -> Bool {
        if event.type == NSEvent.EventType.keyDown {
            if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == NSEvent.ModifierFlags.command.rawValue {
                switch event.charactersIgnoringModifiers! {
                case "x":
                    if NSApp.sendAction(#selector(NSText.cut(_:)), to:nil, from:self) { return true }
                case "c":
                    if NSApp.sendAction(#selector(NSText.copy(_:)), to:nil, from:self) { return true }
                case "v":
                    if NSApp.sendAction(#selector(NSText.paste(_:)), to:nil, from:self) { return true }
                case "z":
                    if NSApp.sendAction(Selector(("undo:")), to:nil, from:self) { return true }
                case "a":
                    if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to:nil, from:self) { return true }
                default:
                    break
                }
            }
        }
        return super.performKeyEquivalent(with: event)
    }
}
