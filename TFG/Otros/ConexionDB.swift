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




typealias Completion = (_ errMsg: String?, _ data: Any?) -> Void

internal class ConexionDB {
    
    let fecha = Funciones().fechaActual()
    private var usuarios = [Usuario]()

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

    internal func addUsuarioFirebase(usu:String,pass:String,email:String,fec:Date) {

        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        let docData: [String: Any] = [
            "usuario": usu,
            "pass": pass,
            "email":email,
            "fecha_creacion":fec,
        ]
        dbFirestore.collection("Usuarios").document(usu).setData(docData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    
    internal func addMovimientoFirebase(usu:String,fecha:String,total:Double) {
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        let docData: [String: Any] = [
            "usuario": usu,
            "fecha":fecha,
            "total":total
        ]
        
        dbFirestore.collection("Movimientos").document(usu).setData(docData)   { err in
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

    internal func listenDocumentoMas(coleccion:String,documento:String, importe:String) -> String
     {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        var terminado = false
        var result:String = "nil"

        dbFirestore.collection(coleccion).document(documento)
            .addSnapshotListener
            { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                var x: String = ""
                var calc: Double = 0.0
                if !terminado{

                    x = String(describing: document.data()!["total"]!)
                    
                    calc = Funciones().claculoSuma(valUno: Double(importe)!, valDos: Double(x)! )
                    print("calc == \(calc)")
                    terminado = true
                    ConexionDB().addMovimientoFirebase(usu: documento, fecha: self.fecha, total: calc)
                    let sCalc: String = String(calc)
                    result = sCalc
                    return
                }
                
            }
        
        while true {
            if result != "nil"{
                return result
            }
        }

    }
    internal func listenDocumentoMenos(coleccion:String,documento:String, importe:String) -> String
    {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        let dbFirestore = Firestore.firestore()
        var terminado = false
        //let contenido = ContenidoViewController()
        var result:String = "nil"
        
        dbFirestore.collection(coleccion).document(documento)
            .addSnapshotListener
            { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                var x: String = ""
                var calc: Double = 0.0
                if !terminado{
                    //print("Current data: \(String(describing: document.data()!["importe"]))")
                    print("Current data: \(String(describing: document.data()!["total"]!))")
                    x = String(describing: document.data()!["total"]!)
                    print("X == \(x)")
                    
                    calc = Funciones().claculoResta(valUno: Double(x)!, valDos: Double(importe)! )
                    print("calc == \(calc)")
                    terminado = true
                    ConexionDB().addMovimientoFirebase(usu: documento, fecha: self.fecha, total: calc)
                    let sCalc: String = String(calc)
                    //contenido.totalRegistro.text = contenido.totalRegistroCalculado//sCalc

                    result = sCalc
                    return
                }
                
        }
        
        while true {
            if result != "nil"{
                return result
            }
        }
        
    }
    internal func datosUsuarioFirebase(usuario usu:String){
        
        //let diccionario: [String : String]
        
        let db: Firestore!
        db = Firestore.firestore()
        let docRef = db.collection("Usuarios").document(usu)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let diccionario = document.data() as! [String : Any]

                self.usuarios.append(Usuario(email: diccionario["email"]! as! String, pass: diccionario["pass"]! as! String, usuario: diccionario["usuario"]! as! String, fecha: diccionario["fecha_creacion"]! as! String) )
                
                for usu in self.usuarios{
                    print(usu.usuario)
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    internal func existeUsuarioFirebase(usuario usu:String)-> Bool
    {
        var existe:Bool = false
        var usuariosEnFirebase:[String] = [""]
        let db: Firestore!
        db = Firestore.firestore()
        db.collection("Usuarios").getDocuments() { (querySnapshot, err) in
            if let err = err {print("Error getting documents: \(err)")}
            else{
                for doc in querySnapshot!.documents
                {
                    usuariosEnFirebase.append(doc.documentID)
                }
                if usuariosEnFirebase.contains(usu)
                {
                    existe = true
                    
                }
            }
        }
        return existe
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
    
    
    internal func handleFirebaseError(error: NSError, vc: UIViewController) {
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                //onComplete?("Invalid email address", nil)
                //Alertas().nuevoUsuario(vc: vc, ms: "Correo invalido.")
                break
            case .wrongPassword:
                //onComplete?("Invalid password", nil)
                //Alertas().nuevoUsuario(vc: vc, ms: "Contraseña invalida.")
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                //onComplete?("Could not create account. Email already in use", nil)
                //Alertas().nuevoUsuario(vc: vc, ms: "Correo existente.")
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

    
}


