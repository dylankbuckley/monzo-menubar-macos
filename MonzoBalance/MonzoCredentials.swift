//
//  xxx.swift
//  MonzoBalance
//
//  Created by Thomas Horrobin on 29/06/2018.
//  Copyright © 2018 Dylan Buckley. All rights reserved.
//

import Foundation

class MonzoCredentials {
    
    init(accountId id: String, accessToken token: String) {
        self.accessToken = token
        self.accountId = id
    }
    
    let accountId, accessToken : String
    
}
