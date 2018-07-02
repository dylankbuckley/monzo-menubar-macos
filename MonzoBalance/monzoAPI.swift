//
//  monzoAPI.swift
//  MonzoBalance
//
//  Created by Dylan Buckley on 15/06/2018.
//  Copyright © 2018 Dylan Buckley. All rights reserved.
//

import Foundation

class monzoAPI {
    
    func fetchBalance(account: String, accessToken: String, success: @escaping([String]) -> Void) {
        let headers = [
            "authorization": "Bearer \(accessToken)"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.monzo.com/balance?account_id=\(account)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared

        
        let task = session.dataTask(with: request as URLRequest) {data, response, err in
            
            if let error = err {
                print(error)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print(httpResponse.statusCode)
                switch httpResponse.statusCode {
                case 200:
                    typealias JSONDict = [String: AnyObject]
                    let json: JSONDict
                    do {
                        json = try JSONSerialization.jsonObject(with: data!, options: []) as! JSONDict
                        success([self.formatAsPounds(rawValue: json["balance"]), self.formatAsPounds(rawValue: json["spend_today"])])
                    } catch {
                        NSLog("JSON Parsing Failed: \(error)")
                    }
                case 401:
                    NSLog("AUTHENTICATION FAILED. REFRESH TOKEN HERE.")
                    
                default:
                    print("Done")
                }
            }
            
            
        }
        task.resume()
    }
    
    func formatAsPounds(rawValue: AnyObject?) -> String {
        let rawAmountPence = rawValue as! Double
        let rawAmountPounds = abs(rawAmountPence / 100.0)
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.numberStyle = .currency
        if let formattedAmount = formatter.string(from: NSNumber(floatLiteral: rawAmountPounds)) {
            return formattedAmount
        } else {
            return "NaN"
        }
    }
}
