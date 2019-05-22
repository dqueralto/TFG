//
//  NetworkManager.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 03/05/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager: NSObject {
    
    func getTweetRequest(byId requestId: String, completion: @escaping (Request?) -> Void) {
        let urlString = "http://localhost:3000/tweetRequest/" + requestId
        Alamofire.request(urlString).response { response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let request = try decoder.decode(Request.self, from: data)
                completion(request)
            } catch let error {
                print(error)
                completion(nil)
            }
        }
    }

    
    func conexionApi(url:String, cosaQueBusco:String) -> String
    {
        var resultado:String = ""
        //modifica el metodo de comunicacion se es necesario
        Alamofire.request(url,method: .post).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                resultado = JSON["etiqueta"]![cosaQueBusco]!! as! String
                
            }
            
        }
        return resultado
        
        
    }
    


}
