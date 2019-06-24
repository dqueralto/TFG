//
//  ViewController.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 13/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite
import SQLite3
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController{
    private var funciones = Funciones()
    private var alertas = Alertas()

    private var db: OpaquePointer?
    private var usuarios = [Usuarios]()
    private var usu: [String] = []
    
    let fecha = Funciones().fechaActual()

    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!

    
    @IBAction func bNuevoUsu(_ sender: Any)
    {
        if funciones.tengoConexion()
        {
            self.nuevoUsuario(vc: self,ms: "")
        }
        else
        {
            self.funciones.comprobarConexion(donde: self)
        }
        
    }

    

    
    override func viewDidLoad(){
        super.viewDidLoad()
    //--------------------------------------------------------------------------------------------------------------------------
        DispatchQueue.global(qos: .background).async {//hilo de fonde
            print("Esto se ejecuta en la cola de fondo")
            self.funciones.comprobarConexion(donde: self)
            self.crearBD()
                
            self.leerValores()

            DispatchQueue.main.async {//hilo principal
                print("Esto se ejecuta en la cola principal, después del código anterior en el bloque externo")
                
                //Creacion de ADMIN en caso de no existir almenos un usuario----------------------------------------------

                
            }//fin hilo de principal
        }//fin del hilo de fondo
        //--------------------------------------------------------------------------------------------------------------------------
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)//de esta forma selecciono el contenido del text field
        
    }

    //-------------------------------
    override func viewDidAppear(_ animated: Bool) {
        //self.alertas.alertaSinConexion(donde: self)
    }
    
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
 
    //-------------------------------------
    @IBAction func informacion(_ sender: Any)
    {
            Alertas().crearAlertainformacion(titulo: "Información", mensaje: "El inicio de sesion requiere que el usuario exista y la contraseña sea correcta. \n\nEn caso de no tener usuario pulse 'No tengo usuario' y rellene el formulario.\n\nAl crear un usuario aceptas que usemos la información facilitada para fines comerciales.", vc: self)
    }
    
    internal func actualizarUsuarios()
    {
        leerValores()
        for usu in usuarios {
            print("\(usu.usuario)  \(ConexionDB().existeUsuarioFirebase(usuario: usu.usuario))")
            print(usu.usuario)
            if !ConexionDB().existeUsuarioFirebase(usuario: usu.usuario){
                self.eliminarUsuario(usu: usu.usuario)
            }
        }
        leerValores()
    }

    @IBAction func Conectar(_ sender: Any)
    {
        leerValores()
        for usu in usuarios {
            print("usua: "+usu.usuario)
            print("mail: "+usu.email)
            print("pass: "+usu.pass)

        }
        if self.usuario.text?.count == 0 || self.contrasenia.text?.count == 0
        {
            Alertas().crearAlertainformacion(titulo: "Cuidadin...", mensaje: "Los campos usuario y conraseña no pueden estar vacíos si quiere conectarse.\nLogica de primero de primaria.", vc: self)
        }else{
        //Creacion de ADMIN en caso de no existir almenos un usuario----------------------------------------------
        if usuarios.count == 0
        {
            let usu = "usu"
            let clave = "usuusu"
            let correo = "usu@dqp.dqp"
            let fecha = self.fecha
            let total = 0.0

            self.insertar(correo: correo, clave: clave, usuario: usu,fec: fecha )
            ConexionDB().addUsuarioFirebase(usu: usu, pass: clave, email: correo, fec: Date())
            ConexionDB().addMovimientoFirebase(usu: usu, fecha: fecha, total: total)
            
            if usuarios.count == 1
            {
                print("usu1 insertado al loguear")
            }
            else if usuarios.count == 0
            {
                print("usu1 no se ha podido insertar al loguearse")
            }
        }

        //----------------------------------------------
        //Comprobacio de posibles fallos + seleccion del tipo de interfaz que se mostrara segun el tipo de usuario ----------------------------------------------
        
        self.filtrarValores(usuario: self.usuario.text!)
            
        print("0")
        print("text: "+self.usuario.text!)
        print("bd: \(usuarios.count)")
        for usu in usuarios
        {
            print("1")
            print("text: "+self.usuario.text!)
            print("bd: "+usu.usuario)

            if self.usuario.text!.elementsEqual(usu.usuario)
            {
                print("2")
                if self.contrasenia.text!.elementsEqual(usu.pass)
                {
                    print("3")
                    performSegue(withIdentifier: "contenido", sender: nil)//asignamos al segue el nombre de la ruta al view de los usuarios
                    return//finalizamos acciones
                }
                else //if usuarios.count==0
                {
                    print("4")
                    self.alertas.alertaPassIncorecta(donde: self)
                    return
                }
            }
            else //if usuarios.count==0
            {
                print("5")
                self.alertas.alertaUsuarioInexistente(donde: self)
                return
            }
        
        }
            if usuarios.count == 0
            {
                print("5")
                self.alertas.alertaUsuarioInexistente(donde: self)
                return
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
        
    }
    
    
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
    //_---------------------------------------------------------------------------------------------------------------


    
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
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (correo TEXT PRIMARY KEY, clave TEXT, usuario TEXT, fec_creacion TEXT)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        leerValores()
        
        
    }
    
    func insertar(correo: String, clave: String, usuario: String,fec: String)  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        let queryString = "INSERT INTO Usuarios (correo, clave, usuario, fec_creacion) VALUES ("+"'"+correo+"','"+clave+"','"+usuario+"','"+fec+"');"
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
            usuarios.append(Usuarios(email: String(correo), pass: String(clave), usuario: String(usuar),fec: String(fec) ))
        }
        
    }
    func filtrarValores(usuario:String){
        
        //PRIMERO LIMPIAMOS LA LISTA "HISTORIAL"
        usuarios.removeAll()
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Usuarios WHERE usuario LIKE '"+usuario+"'"
        
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
            usuarios.append(Usuarios(email: String(correo), pass: String(clave), usuario: String(usuar), fec: String(fec) ))
        }
        
    }
    func filtrarEmail(email:String){
        
        //PRIMERO LIMPIAMOS LA LISTA "HISTORIAL"
        usuarios.removeAll()
        
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = "SELECT * FROM Usuarios WHERE correo LIKE '"+email+"'"
        
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
            usuarios.append(Usuarios(email: String(correo), pass: String(clave), usuario: String(usuar), fec: String(fec) ))
        }
        
    }
    
    internal func eliminarUsuario(usu: String)
    {
        var sentDelUsu: String = "DELETE FROM Usuarios WHERE usuario ='"
        //GUARDAMOS NUESTRA CONSULTA
        let queryString = sentDelUsu+usu+"'"
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
//---------------------------------------------------------------
    internal func existeUsu(usuario usu:String) -> Bool
    {
        var existeUsu:Bool = false
        self.filtrarValores(usuario: usu)
        //print(self.usuarios)
        
        if self.usuarios.count == 1
        {
            existeUsu = true
        }else if self.usuarios.count == 0
        {
            existeUsu = false
        }
        
        return existeUsu
    }
    
    internal func existeCorreo(correo email:String) -> Bool
    {
        var existeCorreo:Bool = false
        self.filtrarEmail(email: email)
        //print(self.usuarios)
        
        if self.usuarios.count == 1
        {
            existeCorreo = true
        }else if self.usuarios.count == 0
        {
            existeCorreo = false
        }
        
        return existeCorreo
    }
    
    internal var usuarioRegistro: String = ""
    internal var emailRegistro: String = ""
    internal var reinicio: Bool = true
    
    internal func nuevoUsuario(vc: UIViewController,ms:String!){
        
        //1.
        let alert = UIAlertController(title: "Nuevo Usuario",
                                      message: "Introduce tus datos por favor.\n"+ms,
                                      
                                      preferredStyle: .alert)
        //2.
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default) { action in
                                        
                                        let usuario = alert.textFields![0].text!
                                        let contrasenia = alert.textFields![1].text!
                                        let confirmacion = alert.textFields![2].text!
                                        let correo = alert.textFields![3].text!
                                        
                                        
                                        //3.
                                        if !usuario.elementsEqual("")
                                        {
                                            if !contrasenia.elementsEqual("")
                                            {
                                                if contrasenia.count >= 6
                                                {
                                                    if contrasenia.elementsEqual(confirmacion)
                                                    {
                                                        if !correo.elementsEqual("")
                                                        {
                                                            if Funciones().isValidEmail(testStr: correo)
                                                            {
                                                                
                                                                if !self.existeUsu(usuario: usuario){
                                                                
                                                                    if !self.existeCorreo(correo: correo){
                                                                        
                                                                        //-------------------------------------
                                                                        
                                                                        self.insertar(correo: correo, clave: contrasenia, usuario: usuario,fec: self.fecha)//Insertamos ficha usuario a Firebase BD
                                                                        
                                                                        ConexionDB().insertarUsuarioFirebase(email: correo, pass: contrasenia, vc: self)//Insertamos usuario en Autenticatro Firebase
                                                                        
                                                                        ConexionDB().addUsuarioFirebase(usu: usuario, pass: contrasenia, email: correo, fec: Date())//Insertamos usuario en BD Firebase
                                                                        
                                                                        ConexionDB().addMovimientoFirebase(usu: usuario, fecha: self.fecha, total: 0)
                                                                        
                                                                        Alertas().crearAlertainformacion(titulo: "Registro Corecto", mensaje: "Usuario registrado correctamente", vc: self)//Alerta informativo cuando el registro es correcto
                                                                        
                                                                        self.reinicio = false
                                                                        
                                                                        //-------------------------------------
                                                                        
                                                                    }else{
                                                                        self.reinicio = true
                                                                        self.usuarioRegistro = usuario
                                                                        //self.emailRegistro = correo
                                                                        self.nuevoUsuario(vc: vc, ms: "El correo ya existe.")
                                                                    }
                                                                    
                                                                }else{
                                                                    self.reinicio = true
                                                                    //self.usuarioRegistro = usuario
                                                                    self.emailRegistro = correo
                                                                    self.nuevoUsuario(vc: vc, ms: "El usuario ya existe.")
                                                                }
                                                                
                                                            }
                                                            else
                                                            {
                                                                self.reinicio = true
                                                                self.usuarioRegistro = usuario
                                                                self.emailRegistro = correo
                                                                self.nuevoUsuario(vc: vc, ms: "El email no tiene el formato correcto.")
                                                            }
                                                        }
                                                        else
                                                        {
                                                            self.reinicio = true
                                                            self.usuarioRegistro = usuario
                                                            self.emailRegistro = correo
                                                            self.nuevoUsuario(vc: vc, ms: "El email es obligatorio.")
                                                        }
                                                    }
                                                    else
                                                    {
                                                        self.reinicio = true
                                                        self.usuarioRegistro = usuario
                                                        self.emailRegistro = correo
                                                        self.nuevoUsuario(vc: vc, ms: "Las contraseñas no coincide.")
                                                    }
                                                }
                                                else
                                                {
                                                    self.reinicio = true
                                                    self.usuarioRegistro = usuario
                                                    self.emailRegistro = correo
                                                    self.nuevoUsuario(vc: vc, ms: "La contraseña es demasiado corta \n(6 caracteres minimo).")
                                                }
                                            }
                                            else
                                            {
                                                self.reinicio = true
                                                self.usuarioRegistro = usuario
                                                self.emailRegistro = correo
                                                self.nuevoUsuario(vc: vc, ms: "La contraseñas es obligatoria.")
                                            }
                                        }
                                        else
                                        {
                                            self.reinicio = true
                                            self.usuarioRegistro = usuario
                                            self.emailRegistro = correo
                                            self.nuevoUsuario(vc: vc, ms: "El usuario es obligatorio.")
                                        }
                                        
        }
        //4.
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default){action in
                                            self.reinicio = false
        }
        //5.
        
        
        alert.addTextField { textUsu in
            textUsu.placeholder = "Usuario"
            if self.reinicio
            {
                textUsu.text = String(self.usuarioRegistro)
                
            }
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Contraseña"
        }
        alert.addTextField { textConfPass in
            textConfPass.isSecureTextEntry = true
            textConfPass.placeholder = "Confirmar contraseña"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "Email"
            if self.reinicio
            {
                textEmail.text = String(self.emailRegistro)
            }
        }
        
        
        
        
        //6.
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        //7.
        
        vc.present(alert, animated: true, completion: nil)
    }

    


}
//---------------------------------------------------------------------------------------------------------------
//OBJETOS
//---------------------------------------------------------------------------------------------------------------


internal class Usuarios
{
    var usuario: String
    var pass: String
    var email: String
    var fec: String

    init (email: String, pass: String,usuario: String,fec:String)
    {
        self.email = email
        self.pass = pass
        self.usuario = usuario
        self.fec = fec
  
    }

}


