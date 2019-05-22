//
//  Request.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 03/05/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation

struct Request: Codable {
    
    let requestId: Int?
    let deviceToken: String?
    
    private enum CodingKeys: String, CodingKey {
        case requestId = "id"
        case deviceToken = "device_token"
    }
    
}
