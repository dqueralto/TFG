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
    private var db: OpaquePointer?
    private var dbName: String = "Datos.sqlite"
    private var usuarios = [Usuario]()
    private var conexion = ConexionDB()
    private var funciones = Funciones()
    private var alertas = Alertas()

    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    @IBOutlet weak var cargando: UIActivityIndicatorView!
    
    
    
    @IBOutlet weak var alerta: UILabel!
    @IBOutlet weak var alerta2: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //--------------------------------------------------------------------------------------------------------------------------
        DispatchQueue.global(qos: .background).async {//hilo de fonde
            print("Esto se ejecuta en la cola de fondo")
            self.conexion.conectarDB()
            func viewDidAppear(_ animated: Bool) {
                // if self.funciones.tengoConexion()
                //{
                self.alertas.alertaSinConexion()
                //}
            }
            
             func didReceiveMemoryWarning() {
                self.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            DispatchQueue.main.async {//hilo principal
                print("Esto se ejecuta en la cola principal, después del código anterior en el bloque externo")
                
                //Creacion de ADMIN en caso de no existir almenos un usuario----------------------------------------------
                if self.usuarios.count == 0
                {
                    self.conexion.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
                    self.conexion.insertarUsuario(usu: "vu", pass: "vu", tipo: "U",nom: "Vista Usario",apell: "Vista Usario",fec_nac: "16/10/1996",email: "vu@vu.vu",sexo: "poco")
                    if self.usuarios.count == 2
                    {
                        print("ADMIN insertado al loguear")
                    }else if self.usuarios.count == 0
                    {
                        print("ADMIN no se ha podido insertar al loguearse")
                    }
                }
                
                for usu in self.usuarios
                {
                    print("usu: "+usu.usuario)
                    print("pass: "+usu.contrasenia)
                    print("tipo: "+usu.tipo)
                }
                print("fin :"+String(self.usuarios.count))
                
            }//fin hilo de principal
        }//fin del hilo de fondo
        //--------------------------------------------------------------------------------------------------------------------------

        
    }
    //-------------------------------


    internal func alertaConexion(){
        self.alertas.crearAlerta(titulo: "Sin Conexion", mensaje: "No dispone de conexion a internet, algunas funciones que requieran dicha conexion podrian verse afectadas o inutilizadas.  Ejemplo: Copia de seguridad automatica/manual...")
    }
    
    internal func crearAlerta(titulo: String, mensaje: String)
    {
        let alert = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("YES")
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("NO")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    //-------------------------------------
    @IBAction func Conectar(_ sender: Any)
    {
        self.cargando.isHidden=false
        //Creacion de ADMIN en caso de no existir almenos un usuario----------------------------------------------
        if self.usuarios.count == 0
        {
            self.conexion.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
            
            self.conexion.insertarUsuario(usu: "vu", pass: "vu", tipo: "U",nom: "Vista Usario",apell: "Vista Usario",fec_nac: "16/10/1996",email: "vu@vu.vu",sexo: "poco")
            if self.usuarios.count == 2
            {
                print("ADMIN insertado al loguear")
            }else if self.usuarios.count == 0
            {
                print("ADMIN no se ha podido insertar al loguearse")
            }
        }
        //----------------------------------------------
        //Comprobacio de posibles fallos + seleccion del tipo de interfaz que se mostrara segun el tipo de usuario ----------------------------------------------
        print("0")
        for usu in usuarios
        {
            alerta.isHidden = true
            alerta2.isHidden = true
            print("1")
            
            if usuario.text!.elementsEqual(usu.usuario) 
            {
                print("2")
                if contrasenia.text!.elementsEqual(usu.contrasenia)
                {
                    print("3")
                    if usu.tipo.elementsEqual("A")//si el tipo del usuario introducido es "A"
                    {
                        print("3.1")
                        performSegue(withIdentifier: "contenidoAdmin", sender: nil)//asignamos al segue el nombre de la ruta al view de los admin
                        self.cargando.isHidden=true
                        return//finalizamos acciones
                        
                    }
                    if usu.tipo.elementsEqual("U")//si el tipo del usuario introducido es "U"
                    {
                        print("3.2")
                        performSegue(withIdentifier: "contenido", sender: nil)//asignamos al segue el nombre de la ruta al view de los usuarios
                        self.cargando.isHidden=true
                        return//finalizamos acciones
                        
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
    //Carga de la interfaz correspondiente al tipo de segue que le indicamos ----------------------------------------------
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
    
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //self.alertaSinConexion.isHidden = true
        self.view.endEditing(true)
    }
    
    
   //* //_---------------------------------------------------------------------------------------------------------------
    internal func conectarDB()
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
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT);", nil, nil, nil) != SQLITE_OK {
                //if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT); CREATE TABLE IF NOT EXISTS Movimientos (num_reg TEXT PRIMARY KEY, FOREIGN KEY(usuario) REFERENCES Usuarios(usuario), fecha TEXT, importe REAL, tipo BOOLEAN);", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        print("BD creada")
        self.crearObjUsuario()
        print("Usuarios creados")
        if usuarios.count == 0
        {
            self.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
            print("ADMIN insertado.")
        }
        
    }
    
    internal func conectarDB(nombreDB: String)
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(nombreDB)
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error al abrir la base de datos")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            //if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT)", nil, nil, nil) != SQLITE_OK {
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT);", nil, nil, nil) != SQLITE_OK {
                //if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT); CREATE TABLE IF NOT EXISTS Movimientos (num_reg TEXT PRIMARY KEY, FOREIGN KEY(usuario) REFERENCES Usuarios(usuario), fecha TEXT, importe REAL, tipo BOOLEAN);", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        print("BD creada")
        self.crearObjUsuario()
        print("Usuarios creados")
        if usuarios.count == 0
        {
            self.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
            print("ADMIN insertado.")
        }
        
    }
    
    
    
    internal func crearObjUsuario(){
        
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Usuarios;"
        
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
            print("illo")
            let usuario = String(cString: sqlite3_column_text(stmt, 0))
            let contrasenia = String(cString: sqlite3_column_text(stmt, 1))
            let tipo = String(cString: sqlite3_column_text(stmt, 2))
            let nombre = String(cString: sqlite3_column_text(stmt, 3))
            let apellidos = String(cString: sqlite3_column_text(stmt, 4))
            let fec_nac = String(cString: sqlite3_column_text(stmt, 5))
            let email = String(cString: sqlite3_column_text(stmt, 6))
            let sexo = String(cString: sqlite3_column_text(stmt, 7))
            print("illo2")
            //AÑADIMOS LOS VALORES A LA LISTA
            self.usuarios.append(Usuario(
                usuario: String(describing: usuario),
                contrasenia: String(describing: contrasenia),
                tipo:String(describing: tipo)
                ,nombre:String(describing: nombre)
                ,apellidos:String(describing: apellidos)
                ,fec_nac:String(describing: fec_nac)
                ,email:String(describing: email)
                ,sexo:String(describing: sexo)
                
            ))
        }
        print("siiiiiiiiii")
    }
    
    internal func insertarUsuario(usu:String,pass:String, tipo: String, nom: String,apell: String, fec_nac: String,email: String, sexo: String)  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios(usuario, contrasenia, tipo, nombre, apellidos, fec_nac, email, sexo) VALUES ('"+usu+"','"+pass+"','"+tipo+"','"+nom+"','"+apell+"','"+fec_nac+"','"+email+"','"+sexo+"');commit;"
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
            //nurvc.alerta2.isHidden = true
            //nurvc.alerta3.isHidden = true
            //nurvc.alerta.isHidden = false
            return
        }
        
        //FINALIZAMOS LA SENTENCIA
        sqlite3_finalize(stmt)
        print("Insertado")
        //displaying a success message
        print("Usuario saved successfully")
        
    }
    
    internal func eliminarUsuarios()
    {
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "DELETE FROM Usuarios;"
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
    
    internal func eliminarUsuario(usu: String)
    {
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "DELETE FROM Usuarios WHERE usuario ='"+usu+"';"
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

    
    //*/
    
    
}


