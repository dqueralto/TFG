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

    
    let base: String
    let rates: [String: Double]
    let date: String

}
