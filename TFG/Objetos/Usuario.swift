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
    var contrasenia: String
    var tipo: String
    var nombre: String??
    var apellidos: String??
    var fec_nac: String??
    var email: String??
    var sexo: String??


    
    init (usuario: String, contrasenia: String, tipo: String, nombre: String??, apellidos: String??, fec_nac: String??, email: String??, sexo: String??)
    //init (usuario: String, contrasenia: String, tipo: String)
        
    {
        self.usuario = usuario
        self.contrasenia = contrasenia
        self.tipo = tipo
        self.nombre = nombre
        self.apellidos = apellidos
        self.fec_nac = fec_nac
        self.email = email
        self.sexo = sexo
    }
 
/*--------------------------------------------------------------------------------------------------------------------------------------*/
    //GET
/*--------------------------------------------------------------------------------------------------------------------------------------*/
    
    func getUsu() -> Usuario
    {
        return self
    }
    
    func getUsuario() -> String
    {
        return self.usuario
    }
    
    func getContrasenia() -> String
    {
        return self.contrasenia
    }
    
    func getTipo() -> String
    {
        return self.tipo
    }
    
    func getNombre() -> String??
    {
        return self.nombre
    }
    
    func getApellidos() -> String??
    {
        return self.apellidos
    }
    
    func getFec_nac() -> String??
    {
        return self.fec_nac
    }
    
    func getEmail() -> String??
    {
        return self.email
    }
    
    func getSexo() -> String??
    {
        return self.sexo
    }

/*--------------------------------------------------------------------------------------------------------------------------------------*/
    //SET
/*--------------------------------------------------------------------------------------------------------------------------------------*/
    
    func setUsuario(usuario: String)
    {
        self.usuario = usuario
    }

    func setContrasenia(contrasenia: String)
    {
        self.contrasenia = contrasenia
    }
    
    func setTipo(tipo: String)
    {
        self.tipo = tipo
    }
    
    func setNombre(nombre: String??)
    {
        self.nombre = nombre
    }
    
    func setApellidos(apellidos: String??)
    {
        self.apellidos = apellidos
    }
    
    func setFec_nac(fec_nac: String??)
    {
        self.fec_nac = fec_nac
    }
    
    func setEmail(email: String??)
    {
        self.email = email
    }
    
    func setSexo(sexo: String??)
    {
        self.sexo = sexo
    }
    
}
