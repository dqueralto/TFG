//
//  Divisa.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 03/04/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation

struct  Divisa:Codable
{
    /*internal init(base: String, rates: [String : Double], date: String) {
        self.base = base
        self.rates = rates
        self.date = date
    }*/
    
    let base: String
    let rates: [String: Double]
    let date: String
    

    

    /*
    var success: Bool
    var timestamp: Int
    var base: String
    var date: String
    var rates: Rates
    
    internal init(success: Bool, timestamp: Int, base: String, date: String, rates: Rates)
    {
        self.success = success
        self.timestamp = timestamp
        self.base = base
        self.date = date
        self.rates = rates
    }
    */

}
