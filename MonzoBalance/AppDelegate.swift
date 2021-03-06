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
    
    @IBAction func emailMagicLink(_ sender: Any) {
        if let url = URL(string: "https://auth.monzo.com/?redirect_uri=https%3A%2F%2Fdevelopers.monzo.com%2Flogin%3Fredirect%3D%252Fapi%252Fplayground&client_id=oauthclient_000094PvINDGzT3k6tz8jp&response_type=code"),
            NSWorkspace.shared.open(url) {
        }
    }
    
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
        
        if userDefaults.string(forKey: "accountId") != nil && userDefaults.string(forKey: "accountId") != nil {
            credentials = MonzoCredentials(accountId: userDefaults.string(forKey: "accountId")!, accessToken: userDefaults.string(forKey: "accessToken")!)
            refreshAndDisplayBalances(credentials: credentials)
        } else {
            refreshAndDisplayBalances(credentials: credentials)
        }
        
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

