//
//  AlertasViewController.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 26/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit

class Alertas: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
     override func viewDidAppear(_ animated: Bool) {
        alertaSinConexion()
     }
    
    override func didReceiveMemoryWarning() {
        self.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    internal func alertaSinConexion(){
        crearAlerta(titulo: "Sin Conexion", mensaje: "No dispone de conexion a internet, algunas funciones que requieran dicha conexion podrian verse afectadas o inutilizadas.  Ejemplo: Copia de seguridad automatica/manual...")
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





}
