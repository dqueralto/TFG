//
//  Usuarios.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 22/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation

internal class Usuario
    
{
    var usuario: String
    var pass: String
    var email: String

    var fecha: String

    
    init (email: String, pass: String,usuario: String, fecha:String)

    {
        self.email = email
        self.pass = pass
        self.usuario = usuario
        self.fecha = fecha

    }
    
    


}
