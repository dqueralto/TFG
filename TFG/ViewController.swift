//
//  ViewController.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 13/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController{
    var db: OpaquePointer?
    var usuarios = [Usuario]()
    var funcion = Funciones()
    //var contenido = [Contenido]()
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    
    
    @IBOutlet weak var alerta: UILabel!
    @IBOutlet weak var alerta2: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.
        //funciones.prueba()
        funcion.crearBD()

        //dbMethod.eliminarUsuarios()
        if usuarios.count == 0
        {
            funcion.insertarAdmin()
        }
        for usu in usuarios
        {
            print(usu.usuario)
            print(usu.contrasenia)
            print(usu.tipo)
            
        }
        
        print("fin")
    }
    
    @IBAction func Conectar(_ sender: Any)
    {
        
        
        if usuarios.count == 0
        {
            funcion.insertarAdmin()
        }
        print("0")
        for usu in usuarios
        {
            alerta.isHidden = true
            alerta2.isHidden = true
            print("1")
            print(usu.usuario)
            print(usu.contrasenia)
            
            if (usuario.text!.elementsEqual(usu.usuario) )
            {
                print("2")
                if contrasenia.text!.elementsEqual(usu.contrasenia)
                {
                    print("3")
                    if usu.tipo.elementsEqual("A")
                    {
                        print("3.1")
                        performSegue(withIdentifier: "contenidoAdmin", sender: nil)
                        return
                        
                    }
                    else if usu.tipo.elementsEqual("U")
                    {
                        print("3.2")
                        performSegue(withIdentifier: "contenido", sender: nil)
                        return
                        
                    }
                }
                else
                {
                    print("4")
                    alerta2.isHidden = false
                    //return
                }
            }
            else
            {
                print("5")
                alerta.isHidden = false
                //return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("--------------------------------------------------------")
        print("1")
        if segue.identifier == "contenido"
        {
            print("2")
            
            if let vistaContenido = segue.destination as? ContenidoViewController
            {
                print("3")
                
                vistaContenido.usuario =  usuario.text!
            }
        }
        
        if segue.identifier == "contenidoAdmin"
        {
            print("4")
            
            if let vistaContenido = segue.destination as? ContenidoAdminViewController
            {
                print("3")
                
                vistaContenido.usuario =  usuario.text!
            }
        }
    }
/*
    //BASE DE DATOS
    //---------------------------------------------------------------------------------------------------------
    
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
    func crearBD()
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Datos.sqlite")
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error al abrir la base de datos")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            //if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT)", nil, nil, nil) != SQLITE_OK {
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT); CREATE TABLE IF NOT EXISTS Movimientos (num_reg TEXT PRIMARY KEY, FOREIGN KEY(usuario) REFERENCES Usuarios(usuario), fecha TEXT, importe REAL, tipo TEXT);", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }/*
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Contenido (titulo TEXT PRIMARY KEY, descripcion TEXT,autor TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }*/
        }
        print("BD creada")
        //eliminarUsuarios()
        crearObjUsuario()
        
        print("Usuarios creados")
        //leerValoresContenido()
        
    }

    
    func crearObjUsuario(){
        
        
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
            let usuario = String(cString: sqlite3_column_text(stmt, 0))
            let contrasenia = String(cString: sqlite3_column_text(stmt, 1))
            let tipo = String(cString: sqlite3_column_text(stmt, 2))

            
            //AÑADIMOS LOS VALORES A LA LISTA
            usuarios.append(Usuario(
                usuario: String(describing: usuario),
                contrasenia: String(describing: contrasenia),
                tipo:String(describing: tipo)

                
            ))
        }
    }
    
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
    
    */
    
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    
}


