//
//  Consultas.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 25/04/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
internal class Consultas
{
    let num_reg:Int
    let usuario:String
    let div_origen:String
    let div_dest:String
    let cant_origen:Double
    let cant_result:Double
    
    init (num_reg:Int,usuario:String,div_origen:String,div_dest:String,cant_origen:Double,cant_result:Double)
    {
        self.num_reg = num_reg
        self.usuario = usuario
        self.div_origen = div_origen
        self.div_dest = div_dest
        self.cant_origen = cant_origen
        self.cant_result = cant_result

    }
    
    

}
