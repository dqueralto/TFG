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
    private var conexion = Conexion()


    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    
    
    @IBOutlet weak var alerta: UILabel!
    @IBOutlet weak var alerta2: UILabel!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //--------------------------------------------------------------------------------------------------------------------------
        DispatchQueue.global(qos: .background).async {//hilo de fonde
            print("Esto se ejecuta en la cola de fondo")
            self.conexion.conectarDB()
            
            DispatchQueue.main.async {//hilo principal
                print("Esto se ejecuta en la cola principal, después del código anterior en el bloque externo")
                //self.conexion.conectarDB()
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
    
    @IBAction func Conectar(_ sender: Any)
    {
        
        //Creacion de ADMIN en caso de no existir almenos un usuario----------------------------------------------
        if usuarios.count == 0
        {
            conexion.insertarUsuario(usu: "admin", pass: "admin", tipo: "A",nom: "a",apell: "a",fec_nac: "a",email: "a",sexo: "a")
            
            if usuarios.count == 1
            {
                print("ADMIN insertado al loguear")
            }else if usuarios.count == 0
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
            
            if (usuario.text!.elementsEqual(usu.usuario) )
            {
                print("2")
                if contrasenia.text!.elementsEqual(usu.contrasenia)
                {
                    print("3")
                    if usu.tipo.elementsEqual("A")//si el tipo del usuario introducido es "A"
                    {
                        print("3.1")
                        performSegue(withIdentifier: "contenidoAdmin", sender: nil)//asignamos al segue el nombre de la ruta al view de los admin
                        return//finalizamos acciones
                        
                    }
                    else if usu.tipo.elementsEqual("U")//si el tipo del usuario introducido es "U"
                    {
                        print("3.2")
                        performSegue(withIdentifier: "contenido", sender: nil)//asignamos al segue el nombre de la ruta al view de los usuarios
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
        self.view.endEditing(true)
    }
    

}


