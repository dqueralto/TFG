//
//  VisualizarUsuariosTableViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

//class VisualizarUsuariosTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
class VisualizarUsuariosViewController: UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var db: OpaquePointer?
    var usuarios = [Usuario]()
    var conexion = Conexion()
    var usu: [String] = []
    var cabeceras: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print("0")
        conexion.conectarDB(nombreDB: "Datos.sqlite")
        genUsu()
        print("0.0")

        // Do any additional setup after loading the view.
    }
    func genUsu()
    {
        for us in usuarios
        {
            
            usu.append("Usuario: "+us.usuario)
            cabeceras.append(["Pasword: "+us.contrasenia,"Tipo: "+us.tipo])
            print("-----------")
            print(us.usuario)
            print(us.contrasenia)
            print(us.tipo)
            print("-----------")

        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //---------------------------------------------------------------------------------------------------------------
    //VISUALIZAR HISTORIAL EN TABLEVIEW
    //---------------------------------------------------------------------------------------------------------------
    //INDICAMOS EL NUMERO DE FILAS QUE TENDRA NUESTRA SECCIÓN A PARTIR DEL TOTAL DE OBJETOS QUE SE HABRAN CREADO GRACIAS A NUESTRA BASE DE DATOS
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //rellenarUsuInfo()
        return cabeceras[section].count
    }
    
      func numberOfSections(in tableView: UITableView) -> Int {
        //rellenarUsuInfo()
        return cabeceras.count
    }
    
      func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return usu[section]
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let celda=tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        celda.textLabel?.text=cabeceras[indexPath.section][indexPath.row]
        return celda
    }

    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    
    
}
