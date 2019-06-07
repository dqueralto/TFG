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
        crearAlertainformacion(titulo: "Sin Conexion", mensaje: "La App no dispone de conexion a internet, algunas funcionalidades pueden verse afectadas o deshabilitadas, por ejemplo el gestor que sera deshabilitado o el conversor que no dejara de dar cambios actualizador. \n\nCuando se recupere la conexion todo sera habilitado nuevamente de forma silenciosa. \n\nDisculpe las molestias.",vc: donde)
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

}

