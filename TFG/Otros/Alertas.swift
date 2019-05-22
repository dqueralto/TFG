//
//  File.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 28/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
import UIKit
import SQLite3
class Alertas{
    //internal var conexion = ConexionDB()
    internal var usuarioRegistro: String = ""
    internal var emailRegistro: String = ""
    internal var reinicio: Bool = false
    
    internal func alertaSinConexion(donde:UIViewController){
        crearAlertainformacion(titulo: "Sin Conexion", mensaje: "La App no dispone de conexion a internet, los resultados de las conversiones se haran con los cambios monetarios del 30-04-2019",vc: donde)
    }
        
        
    internal func alertaPassIncorecta(donde:UIViewController){
        crearAlertainformacion(titulo: "Contraseña Incorrecta", mensaje: "La contraseña introducidas no es correcta.",vc: donde)
    }
    
    internal func alertaUsuarioInexistente(donde:UIViewController){
        crearAlertainformacion(titulo: "Usuario Inexistente", mensaje: "El usuario indicado no existe.",vc: donde)
    }
    
    internal func alertaPassNoCoincidentes(donde:UIViewController){
        crearAlertainformacion(titulo: "Contraseñas Incorrectas", mensaje: "Las contraseñas introducidas no coinciden.",vc: donde)
    }
    
    internal func crearAlertainformacion(titulo: String, mensaje: String, vc: UIViewController)
    {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        //cramos el boton
        alert.addAction(UIAlertAction(title: "Vale", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("Vale")
        }))
        
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    internal func crearAlertaOpciones(titulo: String, mensaje: String, vc: UIViewController)
    {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Sí", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("Sí")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    
    private var db: OpaquePointer?
    private var usuarios = [Usuarios]()
    private var usu: [String] = []
    
    func crearBD()
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Usuarios.sqlite")
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (correo TEXT PRIMARY KEY, clave TEXT, usuario TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
        
        
    }
    
    func insertar(correo: String, clave: String, usuario: String)  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios (correo, clave, usuario) VALUES ("+"'"+correo+"','"+clave+"','"+usuario+"');"
        //PREPARAMOS LA SENTENCIA
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        
        //EJECUTAMOS LA SENTENCIA PARA INSERTAR LOS VALORES
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("fallo al insertar en Usuarios: \(errmsg)")
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        //displaying a success message
        print("Histo saved successfully")
        
    }
    func leerValores(){
        
        //PRIMERO LIMPIAMOS LA LISTA "HISTORIAL"
        usuarios.removeAll()
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Usuarios"
        
        //PUNTERO DE INSTRUCCIÓN
        var stmt:OpaquePointer?
        
        //PREPARACIÓN DE LA CONSULTA
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //RECORREMOS LOS REGISTROS
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let correo = String(cString: sqlite3_column_text(stmt, 0))
            let clave = String(cString: sqlite3_column_text(stmt, 1))
            let usuar = String(cString: sqlite3_column_text(stmt, 2))
            let fec = String(cString: sqlite3_column_text(stmt, 3))

            //AÑADIMOS LOS VALORES A LA LISTA
            usuarios.append(Usuarios(email: String(correo), pass: String(clave), usuario: String(usuar), fec: fec))
        }
        
    }
    
}

