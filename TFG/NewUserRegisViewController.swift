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
    var conexion = ConexionDB()
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

        conexion.conectarDB(nombreDB: "Datos.sqlite")
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
                conexion.insertarUsuario(usu: usuario.text!, pass: contrasenia.text!,tipo: "U",nom: "",apell: "",fec_nac: "",email: "",sexo: "")
                //leerUsuarios()
                conexion.crearObjUsuario()
                autologin()
                return
            }
            
        }
        
        
        
    }
    
    func autologin(){
        
        //leerUsuarios()
        conexion.crearObjUsuario()
        if usuarios.count == 0
        {
            conexion.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "null",apell: "null",fec_nac: "null",email: "null",sexo: "null")
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
    

    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    

}
