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
    let userDefaults = UserDefaults()
    
    // GET THESE CREDENTIALS FROM DEVELOPERS.MONZO.COM
    // DO NOT PUBLISH THEM IN PUBLIC.
    var credentials = MonzoCredentials(accountId: "", accessToken: "")
    // END
    
    func setCredentials(newCredentials: MonzoCredentials) -> Void {
        if newCredentials.accessToken != "" {
            
            userDefaults.set(newCredentials.accountId, forKey: "accountId")
            userDefaults.set(newCredentials.accessToken, forKey: "accessToken")
            refreshAndDisplayBalances(credentials: MonzoCredentials(accountId: userDefaults.string(forKey: "accountId")!, accessToken: userDefaults.string(forKey: "accessToken")!))
            credentials = newCredentials

        }
    }
    
    func refreshAndDisplayBalances(credentials: MonzoCredentials) {
        monzoApi.fetchBalance(account: credentials.accountId, accessToken: credentials.accessToken) { (balance) in
            DispatchQueue.main.async {
                self.statusItem.title = balance[0]
                if let spendToday = self.monzoMenu.item(withTag: 1) {
                    spendToday.isHidden = false
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
        if credentials.accessToken != "" {
            statusItem.title = "Loading Balance"
        } else {
            statusItem.title = "Enter Your Monzo Credentials"
            if let spendToday = self.monzoMenu.item(withTag: 1) {
                spendToday.isHidden = true
            }
        }
        
        statusItem.menu = monzoMenu
        
        credentials = MonzoCredentials(accountId: userDefaults.string(forKey: "accountId")!, accessToken: userDefaults.string(forKey: "accessToken")!)
        
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
        let viewController = CredentialsInputWindow(nibName: NSNib.Name( "CredentialsInputWindow" ), bundle: Bundle(identifier: "MonzoBalance"))
        let window = NSWindow(contentViewController: viewController)
        window.makeKeyAndOrderFront(self)
        window.title = "Enter Your Credentials"
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @IBAction func spentTodayClicked(_ sender: NSMenuItem) {
        print("Clicked Spent Today")
    }
}

