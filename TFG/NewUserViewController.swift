//
//  NewUserViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 01/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class NewUserViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var db: OpaquePointer?
    var usuarios = [Usuario]()
    var conexion = ConexionDB()
    var pickerData: [String] = [String]()
    var tipo: String = "A"

    
    @IBOutlet weak var usuario: UITextField!
    @IBOutlet weak var confirmarContrasenia: UITextField!
    @IBOutlet weak var contrasenia: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var alerta: UILabel!
    
    @IBOutlet weak var alerta2: UILabel!
    
    @IBOutlet weak var alerta3: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {//hilo de fonde
            print("Esto se ejecuta en la cola de fondo")
            ViewController().conectarDB()
            
            DispatchQueue.main.async {//hilo principal
                print("Esto se ejecuta en la cola principal, después del código anterior en el bloque externo")
                for usu in self.usuarios
                {
                    print(usu.usuario)
                    print(usu.contrasenia)
                    print(usu.tipo)
                    
                }
                self.pickerData = ["ADMINISTRADOR", "USUARIO"]
                self.picker.delegate = self
                self.picker.dataSource = self
            }
            
        }
        


        
        
    }
    
    @IBAction func nuevo(_ sender: Any)
    {
        ViewController().crearObjUsuario()
        print("000")
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
                ConexionDB().insertarUsuarioSQLite(usu: usuario.text!, pass: contrasenia.text!,tipo: tipo,nom: "null",apell: "null",fec_nac: "null",email: "null",sexo: "null")
                //insertar()
                return
            }
        }
        //leerValores()
        //conexion.crearObjUsuario()
    }
    
    
    
    //LISTA----------------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns of data
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    // The number of rows of data
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if pickerData[row].elementsEqual("ADMINISTRADOR") {
            self.tipo = "A"
        }else if pickerData[row].elementsEqual("USUARIO"){
            self.tipo = "U"
        }
        
    }
    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    
}


