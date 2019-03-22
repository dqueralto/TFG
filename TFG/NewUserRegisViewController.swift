//
//  NewUserViewController.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 18/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class NewUserRegisViewController: UIViewController {
    var db: OpaquePointer?
    var usuarios = [Usuario]()
    var funcion = Funciones()
    var pickerData: [String] = [String]()
    var tipo: String = "A"
    //var dbMethod = DBComunMethod()
    
    @IBOutlet weak var alerta: UILabel!
    @IBOutlet weak var alerta2: UILabel!
    @IBOutlet weak var alerta3: UILabel!
    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    @IBOutlet weak var confirmarContrasenia: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        funcion.crearBD()
        //conectarDB()
        for usu in usuarios
        {
            print(usu.usuario)
            print(usu.contrasenia)
            print(usu.tipo)
            
        }

        // Do any additional setup after loading the view.
    }
    @IBAction func registrar(_ sender: Any)
    {
        
        for usu in usuarios
        {
            
            alerta.isHidden = true
            alerta2.isHidden = true
            alerta3.isHidden = true
            print("1")
            print(usu.usuario)
            print(usu.contrasenia)
            if !contrasenia.text!.elementsEqual(confirmarContrasenia.text!)
            {
                print("2")
                print("No Coinciden las Contraseña")
                alerta3.isHidden = false
                return
                
            }else
            {
                print("3")
                //alerta.isHidden = true
                alerta2.isHidden = false
                print(usuario.text!)
                print(contrasenia.text!)
                print(confirmarContrasenia.text!)
                print(tipo)
                funcion.insertarUsuario(usu: usuario.text!, pass: contrasenia.text!,tipo: "U")
                //leerUsuarios()
                funcion.crearObjUsuario()
                autologin()
                return
            }
            
        }
        
        
        
    }
    
    func autologin(){
        
        //leerUsuarios()
        funcion.crearObjUsuario()
        if usuarios.count == 0
        {
            funcion.insertarAdmin()
        }
        print("auto 0")
        
        for usu in usuarios
        {
            alerta.isHidden = true
            alerta2.isHidden = true
            print("auto 1")
            print(usu.usuario)
            print(usu.contrasenia)
            
            if (usuario.text!.elementsEqual(usu.usuario) )
            {
                print("auto 2")
                if contrasenia.text!.elementsEqual(usu.contrasenia)
                {
                    print("auto 3")
                    /*if usu.tipo.elementsEqual("A")
                    {
                        print("3.1")
                        performSegue(withIdentifier: "contenidoAdmin", sender: nil)
                        return
                        
                    }
                    else */
                    if usu.tipo.elementsEqual("U")
                    {
                        print("auto 3.2")
                        performSegue(withIdentifier: "contenidoRegistrar", sender: nil)
                        return
                    }
                }
                else
                {
                    print("auto 4")
                    alerta2.isHidden = false
                    //return
                }
            }
            else
            {
                print("auto 5")
                alerta.isHidden = false
                //return
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        print("--------------------------------------------------------")
        print("1")
        if segue.identifier == "contenidoRegistrar"
        {
            print("2")
            
            if let vistaContenido = segue.destination as? ContenidoViewController
            {
                print("3")
                
                vistaContenido.usuario =  usuario.text!
            }
        }
        /*
        if segue.identifier == "contenidoAdmin"
        {
            print("4")
            
            if let vistaContenido = segue.destination as? ContenidoAdminViewController
            {
                print("3")
                
                vistaContenido.usuario =  usuario.text!
            }
        }*/
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
    
    public func insertarUsuario(usu:String,pass:String)  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios VALUES ('"+String(usu)+"','"+String(pass)+"','U')"
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
            alerta2.isHidden = true
            alerta3.isHidden = true
            alerta.isHidden = false
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Histo saved successfully")
        
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
            
            print(usuario)
            print(contrasenia)
            print(tipo)
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
    //---------------------------------------------------------------------------------------------------------
     
*/

    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    

}
