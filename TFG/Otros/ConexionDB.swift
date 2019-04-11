//
//  ConexionDB.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 22/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//
import UIKit
import Foundation
import SQLite
import SQLite3
import Firebase
import FirebaseAuth
import FirebaseFunctions
import Firebase


//import SQLite
//typealias Completion = (_ errMsg: String?, _ data: Any?) -> Void


typealias Completion = (_ errMsg: String?, _ data: Any?) -> Void

internal class ConexionDB {
    
    //-------------------------SQLite------------------------------------------------------------------
    
    private var db: OpaquePointer?
    private var usuarios = [Usuario]()
    private var dbName = "Datos.sqlite"
    
    private var sentAddTabUsu: String = "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT, apellidos TEXT, fec_nac TEXT, email TEXT,sexo TEXT);"
    private var sentDelUsu: String = "DELETE FROM Usuarios WHERE usuario ='"
    private var sentDelAllUsu: String = "DELETE FROM Usuarios;COMMIT;"
    private var sentInsertUsu: String = "INSERT INTO Usuarios(usuario, contrasenia, tipo, nombre, apellidos, fec_nac, email, sexo) VALUES ('"
    
    internal func conectarDBSQLite(){
        let db = try! Connection("/Datos.sqlite")
        
        let users = Table("usuarios")
        let usu = Expression<String>("usuario")
        let pass = Expression<String>("pass")
        let tipo = Expression<String>("tipo")
        let nom = Expression<String?>("nombre")
        let ape = Expression<String?>("apellidos")
        let fec_naz = Expression<String?>("fec_nac")
        let email = Expression<String>("email")
        let sexo = Expression<String?>("sexo")
        
        try! db.run(users.create { t in
            t.column(usu, primaryKey: true)
            t.column(pass)
            t.column(tipo)
            t.column(nom)
            t.column(ape)
            t.column(fec_naz)
            t.column(email, unique: true)
            t.column(sexo)
            print("usuarios parece creado")
            
        })
        
        let movimientos = Table("movimientos")
        let numReg = Expression<String>("numero_registro")
        let usuar = Expression<String>("usuario")
        let fecha = Expression<String>("fecha")
        let importe = Expression<Double>("importe")
        let tipoIngreso = Expression<Bool>("tipo")
        
        
        try! db.run(movimientos.create { t in
            t.column(numReg, primaryKey: true)
            t.column(usuar)
            t.column(fecha)
            t.column(importe)
            t.column(tipoIngreso)
            print("movimientos parece creado")
            
        })
        
    }
    
    
    //------------------------Firebase-------------------------------------------------------------
    var dbFirestore = Firestore.firestore()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // [START default_firestore]
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        // [END default_firestore]
        print(db) // silence warning
        return true
    }

    internal func addUsuarioFirebase(usu:String,pass:String,tipo:String,nom:String,apell:String,fec_nac:String,email:String,sexo:String) {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        let docData: [String: Any] = [
            "usuario": usu,
            "pass": pass,
            "tipo": tipo,
            "nombre":nom,
            "apellido":apell,
            "fechaNacimiento":fec_nac,
            "email":email,
            "sexo":sexo
        ]
        dbFirestore.collection("Usuarios").document(usu).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    internal func addMovimientoFirebase(numReg:Int,usu:String,fecha:String,importe:Double,tipo:Bool,total:Double) {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        let docData: [String: Any] = [
            "numReg": numReg,
            "usuario": usu,
            "fecha":fecha,
            "importe":importe,
            "tipo": tipo,
            "total":total
        ]
        dbFirestore.collection("Movimientos").document(usu).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    internal func delDegistroFirebase(coleccion:String,documento:String)
    {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        
        dbFirestore.collection(coleccion).document(documento).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    internal func delCampoFirebase(coleccion:String,documento:String,campo:String)
    {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        
        dbFirestore.collection(coleccion).document(documento).updateData([
            campo: FieldValue.delete(),
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    internal func modInformacionFirebase(coleccion:String,documento:String,campo:String,dato:String)
    {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        
        dbFirestore.collection(coleccion).document(documento).updateData([
            campo:dato
        ])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    internal func listenDocumento(coleccion:String,documento:String)
     {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        
        dbFirestore.collection(coleccion).document(documento)
            .addSnapshotListener
            { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                print("Current data: \(String(describing: document.data()))")
        }
        // [END listen_document]
    }
    
    func filtroUsuarioFirebase(coleccion:String,usu:String){//-> String{
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        let docRef = dbFirestore.collection(coleccion).document(usu)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
        //return usuario.path
        
        // [START example_filters]
        //citiesRef.whereField("state", isEqualTo: "CA")
        //citiesRef.whereField("population", isLessThan: 100000)
        //citiesRef.whereField("name", isGreaterThanOrEqualTo: "San Francisco")
        // [END example_filters]
    }
    
    //---------------------------------------------------------
    internal func insertarUsuarioFirebase(email:String, pass:String, vc: UIViewController)
    {
        Auth.auth().createUser(withEmail: email, password: pass) { (authResult, error) in
            if error != nil {
                self.handleFirebaseError(error: error! as NSError,vc: vc)
            }
        }
    }
    
    
    func handleFirebaseError(error: NSError, vc: UIViewController) {
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                //onComplete?("Invalid email address", nil)
                Alertas().nuevoUsuario(vc: vc, ms: "Correo invalido.")
                break
            case .wrongPassword:
                //onComplete?("Invalid password", nil)
                Alertas().nuevoUsuario(vc: vc, ms: "Contraseña invalida.")
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                //onComplete?("Could not create account. Email already in use", nil)
                Alertas().nuevoUsuario(vc: vc, ms: "Correo existente.")
                break
            case .userNotFound:
                //onComplete?("Correct you email or sign up if you not have an account", nil)
                break
            default:
            break
                //onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    internal func conectarDB()
    {
        //INDICAMOS DONDE SE GUARDARA LA BASE DE DATOS Y EL NOMBRE DE ESTAS
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName)
        //INDICAMOS SI DIERA ALGUN FALLO AL CONECTARSE
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error al abrir la base de datos")
        }
        else {//SI PODEMOS CONECTARNOS A LA BASE DE DATOS CREAREMOS LA ESTRUCTURA DE ESTA, SI NO EXISTIERA NO SE HARIA NADA
            print("base abierta")
            //if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Usuarios (usuario TEXT PRIMARY KEY, contrasenia TEXT, tipo TEXT, nombre TEXT)", nil, nil, nil) != SQLITE_OK {
            if sqlite3_exec(db, sentAddTabUsu, nil, nil, nil) != SQLITE_OK {
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
            self.insertarUsuarioSQLite(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
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
            if sqlite3_exec(db, sentAddTabUsu, nil, nil, nil) != SQLITE_OK {
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
            self.insertarUsuarioSQLite(usu: "admin", pass: "admin", tipo: "A",nom: "Administrador",apell: "Administrador",fec_nac: "16/10/1996",email: "admin@admin.admin",sexo: "poco")
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
    
    internal func insertarUsuarioSQLite(usu:String,pass:String, tipo: String, nom: String,apell: String, fec_nac: String,email: String, sexo: String)  {
        //CREAMOS EL PUNTERO DE INSTRUCCIÓN
        var stmt: OpaquePointer?
        
        //CREAMOS NUESTRA SENTENCIA
        //let queryString = sentInsertUsu+usu+"','"+pass+"','"+tipo+"','"+nom+"','"+apell+"','"+fec_nac+"','"+email+"','"+sexo+"');commit;"
        let queryString = "INSERT INTO Usuarios(usuario, contrasenia, tipo, nombre, apellidos, fec_nac, email,sexo) VALUES ('usu','usu','U','u','u','u','u','u');"

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
        let queryString = sentDelAllUsu
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
        let queryString = sentDelUsu+usu+"';COMMIT;"
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
    }*/
    
    //
    //------------------------------

    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    


}


