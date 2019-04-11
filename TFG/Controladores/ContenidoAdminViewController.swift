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
    internal var usuario: String?
    internal var db: OpaquePointer?
    internal var usuarios = [Usuario]()
    internal var conexion = ConexionDB()
    internal var cabecera: String?

    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var usu: UILabel!
    @IBOutlet weak var alertContenEli: UILabel!
    @IBOutlet weak var alertUsuEli: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //conexion.conectarDB(nombreDB: "Datos.sqlite")
        //usu.text = self.usuario
        
        cabecera = self.usuario! 
        titulo.title = cabecera
        //alertUsuEli.isHidden = true
        //alertContenEli.isHidden = true
        // Do any additional setup after loading the view.
    }
    
   
    @IBAction func borrarTodosUsuarios(_ sender: Any)
    {
        //alertContenEli.isHidden = true
        //conexion.eliminarUsuarios()
        //leerUsuarios()
        //conexion.crearObjUsuario()
        //conexion.insertarUsuarioSQLite(usu: "admin", pass: "admin", tipo: "A",nom: "null",apell: "null",fec_nac: "null",email: "null",sexo: "null")
        //alertUsuEli.isHidden = false
    }
   
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    
    //---------------------------------------------------------------------------------------------------------
    
}
