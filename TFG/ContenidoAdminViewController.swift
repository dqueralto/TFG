//
//  ContenidoAdminViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 19/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class ContenidoAdminViewController: UIViewController {
    var usuario: String?
    var db: OpaquePointer?
    var usuarios = [Usuario]()
    var funcion = Funciones()
    
    @IBOutlet weak var usu: UILabel!
    @IBOutlet weak var alertContenEli: UILabel!
    @IBOutlet weak var alertUsuEli: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        funcion.crearBD()
        usu.text = self.usuario
        alertUsuEli.isHidden = true
        alertContenEli.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    /*
    //---------------------------------------------------------------------------------------------------------
    func conectarDB()
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Datos.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
        }
        else {
            print("base abierta")
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT); CREATE TABLE IF NOT EXISTS Movimientos (num_reg TEXT PRIMARY KEY, FOREIGN KEY(usuario) REFERENCES Usuarios(usuario), fecha TEXT, importe REAL, tipo BOOLEAN);", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerUsuarios()
    }
    
    func leerUsuarios(){
        
        
        
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

            
            
            //AÑADIMOS LOS VALORES A LA LISTA
            while(sqlite3_step(stmt) == SQLITE_ROW){
                let usuario = String(cString: sqlite3_column_text(stmt, 0))
                let contrasenia = String(cString: sqlite3_column_text(stmt, 1))
                let tipo = String(cString: sqlite3_column_text(stmt, 2))
                //let nombre = String(cString: (sqlite3_column_text(stmt, 3)))
                //let apellidos = String(cString: (sqlite3_column_text(stmt, 4)))
                //let fec_nac = String(cString: (sqlite3_column_text(stmt, 5)))
                //let email = String(cString: (sqlite3_column_text(stmt, 6)))
                //let sexo = String(cString: (sqlite3_column_text(stmt, 7)))
                
                //AÑADIMOS LOS VALORES A LA LISTA
                usuarios.append(Usuario(
                    usuario: String(describing: usuario),
                    contrasenia: String(describing: contrasenia),
                    tipo:String(describing: tipo)
                    //,nombre:String(describing: nombre)
                    //,apellidos:String(describing: apellidos)
                    //,fec_nac:String(describing: fec_nac)
                    //,email:String(describing: email)
                    //,sexo:String(describing: sexo)
                    
                ))
        }
        
        
        
    }
    */
    @IBAction func borrarTodosUsuarios(_ sender: Any)
    {
        alertContenEli.isHidden = true
        funcion.eliminarUsuarios()
        //leerUsuarios()
        funcion.crearObjUsuario()
        funcion.insertarAdmin()
        alertUsuEli.isHidden = false
    }
   /*
    func insertarAdmin()  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios (usuario,contrasenia,tipo) VALUES ('admin','admin','A')"
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
            print("fallo al insertar en usuarios: \(errmsg)")
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Histo saved successfully")
        
    }
    
    func eliminarUsuarios()
    {
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "DELETE FROM Usuarios"
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var deleteStatement: OpaquePointer? = nil
        
        //PREPARACIÓN DE LA CONSULTA
        if sqlite3_prepare(db, queryString, -1, &deleteStatement, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print(queryString)
            print("error preparing insert: \(errmsg)")
            return
        }
        //ELIMINAMOS LOS REGISTROS
        if sqlite3_prepare_v2(db, queryString, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(deleteStatement)
        //insertarAdmin()
    }
    
    */
    
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    
}
