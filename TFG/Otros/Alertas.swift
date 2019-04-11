//
//  File.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 28/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import Foundation
import UIKit

class Alertas{
    //internal var conexion = ConexionDB()
    internal var usuarioRegistro: String = ""
    internal var emailRegistro: String = ""
    internal var reinicio: Bool = false
    
    internal func alertaSinConexion(donde:UIViewController){
        crearAlertainformacion(titulo: "Sin Conexion", mensaje: "No dispone de conexion a internet, algunas funciones que requieran dicha conexion podrian verse afectadas o inutilizadas.  Ejemplo: Copia de seguridad automatica/manual...",vc: donde)
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
                                                                //ConexionDB().insertarUsuarioFirebase(email: correo, pass: contrasenia,vc: vc)
                                                                //ViewController().insertarUsuarioSQLite(usu: usuario, pass: contrasenia, tipo: "U", nom: "u", apell: "u", fec_nac: "u", email: correo, sexo: "otro")
                                                                
                                                                ConexionDB().addUsuarioFirebase(usu: usuario, pass: contrasenia, tipo: "U",nom: "", apell: ""
                                                                    ,fec_nac: "",email: correo,sexo: "poco")
                                                                self.reinicio = false
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
            textUsu.placeholder = "usuario"
            if self.reinicio
            {
                textUsu.text = String(self.usuarioRegistro)
                
            }
        }
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "contraseña"
        }
        alert.addTextField { textNombre in
            textNombre.isSecureTextEntry = true
            textNombre.placeholder = "Confirmar contraseña"
        }
        alert.addTextField { textEmail in
            textEmail.placeholder = "email"
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

