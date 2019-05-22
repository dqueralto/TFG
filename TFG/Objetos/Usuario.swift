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
    //var id: Int
    var usuario: String
    var pass: String
    var email: String
    //var tipo: String
    //var tipo: String
    //var nombre: String
    //var apellidos: String
    var fecha: String
    //var email: String
    //var sexo: String


    
    //init (usuario: String, contrasenia: String, tipo: String, nombre: String, apellidos: String, fec_nac: String, email: String, sexo: String)
    //init (usuario: String,email: String, pass: String, tipo:String)
    init (email: String, pass: String,usuario: String, fecha:String)

    //init (usuario: String, contrasenia: String, tipo: String)
    {
        self.email = email
        self.pass = pass
        self.usuario = usuario
        self.fecha = fecha
        //self.tipo = tipo
        
        //self.tipo = tipo
        //self.nombre = nombre
        //self.apellidos = apellidos
        //self.fec_nac = fec_nac
        //self.email = email
        //self.sexo = sexo
    }
    
    

/*--------------------------------------------------------------------------------------------------------------------------------------*/
    //GET
/*--------------------------------------------------------------------------------------------------------------------------------------*/
   /*
    internal func getUsu() -> Usuario
    {
        return self
    }
    
    internal func getUsuario() -> String
    {
        return self.usuario
    }
    
    internal func getContrasenia() -> String
    {
        return self.contrasenia
    }
    
    internal func getTipo() -> String
    {
        return self.tipo
    }
    
    internal func getNombre() -> String
    {
        return self.nombre
    }
    
    internal func getApellidos() -> String
    {
        return self.apellidos
    }
    
    internal func getFec_nac() -> String
    {
        return self.fec_nac
    }
    
    internal func getEmail() -> String
    {
        return self.email
    }
    
    internal func getSexo() -> String
    {
        return self.sexo
    }

/*--------------------------------------------------------------------------------------------------------------------------------------*/
    //SET
/*--------------------------------------------------------------------------------------------------------------------------------------*/
    
    internal func setUsuario(usuario: String)
    {
        self.usuario = usuario
    }

    internal func setContrasenia(contrasenia: String)
    {
        self.contrasenia = contrasenia
    }
    
    internal func setTipo(tipo: String)
    {
        self.tipo = tipo
    }
    
    internal func setNombre(nombre: String)
    {
        self.nombre = nombre
    }
    
    internal func setApellidos(apellidos: String)
    {
        self.apellidos = apellidos
    }
    
    internal func setFec_nac(fec_nac: String)
    {
        self.fec_nac = fec_nac
    }
    
    internal func setEmail(email: String)
    {
        self.email = email
    }
    
    internal func setSexo(sexo: String)
    {
        self.sexo = sexo
    }
    */
}
