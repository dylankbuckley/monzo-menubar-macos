//
//  AppDelegate.swift
//  MonzoBalance
//
//  Created by Dylan Buckley on 15/06/2018.
//  Copyright © 2018 Dylan Buckley. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var monzoMenu: NSMenu!
    let monzoApi = monzoAPI()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    // GET THESE CREDENTIALS FROM DEVELOPERS.MONZO.COM
    // DO NOT PUBLISH THEM IN PUBLIC.
    var credentials = MonzoCredentials(accountId: "ACCOUNT NUMBER HERE", accessToken: "ACCESS TOKEN HERE")
    // END
    
    func refreshAndDisplayBalances(credentials: MonzoCredentials) {
        monzoApi.fetchBalance(account: credentials.accountId, accessToken: credentials.accessToken) { (balance) in
            DispatchQueue.main.async {
                self.statusItem.title = balance[0]
                if let spendToday = self.monzoMenu.item(withTag: 1) {
                    spendToday.title = "\(balance[1]) Spent Today"
                }
            }
        }
    }
    
    @objc func refreshBalances(){
        refreshAndDisplayBalances(credentials: credentials)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem.title = "Loading Balance"
        statusItem.menu = monzoMenu
        
        refreshAndDisplayBalances(credentials: credentials)
        
        _ = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(refreshBalances), userInfo: nil, repeats: true)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func enterCredentialsManually(_ sender: Any) {
        let wc = CredentialsInputWindowController(windowNibName: NSNib.Name( "CredentialsInputWindow" ))
        wc.showWindow(nil)
    }
    
    @IBAction func spentTodayClicked(_ sender: NSMenuItem) {
        print("Clicked Spent Today")
    }
}

