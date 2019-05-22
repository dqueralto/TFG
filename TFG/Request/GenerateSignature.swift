//
//  GenerateSignature.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 03/05/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
import Alamofire

class GenerateSignature: NSObject {
    var key:String = ""
    
    func generarSignature(idUsuario id: String, email correo: String, clave password:String) -> String {
        
        let signature:String = ""
        
        
        
        return signature
    }
    
    
    
    
    
    
    func conexionApimegasur(url:String, idUsuario id:Int, emailUsuario email:String, passwordUsuario password:String, signature:String) -> String
    {
        //let url:String = "https://m.megasur.es/api/v1/user/login?id=\(id)?email=\(email)?password=\(password)?signature=\(signature)"
        
        let url = "https://m.megasur.es/api/v1/user/login?id=\(id)&email=\(email)&password=\(password)"
        var resultado:String = ""
        
        //conectamos
        Alamofire.request(url,method: .post).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                //resultado = JSON["etiqueta"]![cosaQueBusco]!! as! String
                resultado = JSON[""]! as! String
            }
            
        }
        return resultado
        
        
    }
}
