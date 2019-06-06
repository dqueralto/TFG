//
//  Movimientos.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 22/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation

internal class Consultas{
    //var usu = [Usuario]()
    
    var num_reg: Int
    var usuario: String
    var fecha: String
    var importe: Double
    var tipo: String

    
    
    
    init (num_reg: Int, usuario: String, fecha: String, importe: Double, tipo: String)
        //init (usuario: String!, contrasenia: String!, tipo: String!)
        
    {
        self.num_reg = num_reg
        self.usuario = usuario
        self.fecha = fecha
        self.importe = importe
        self.tipo = tipo
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------------------*/
    //GET
    /*--------------------------------------------------------------------------------------------------------------------------------------*/
    
    func getMov() -> Movimiento
    {
        return self
    }
    
    func getNum_reg() -> Int
    {
        return self.num_reg
    }
    
    func getUsuario() -> String
    {
        return self.usuario
    }
    
    func getFecha() -> String
    {
        return self.fecha
    }
    
    func getImporte() -> Double
    {
        return self.importe
    }
    
    func getTipo() -> String
    {
        return self.tipo
    }
    
    /*--------------------------------------------------------------------------------------------------------------------------------------*/
    //SET
    /*--------------------------------------------------------------------------------------------------------------------------------------*/
    
    func setNum_reg(num_reg: Int)
    {
        self.num_reg = num_reg
    }
    
    func setUsuario(usuario: String)
    {
        self.usuario = usuario
    }
    
    func setFecha(fecha: String)
    {
        self.fecha = fecha
    }
    
    func setImporte(importe: Double)
    {
        self.importe = importe
    }
    
    func setTipo(tipo: String)
    {
        self.tipo = tipo
    }
    
}

    

