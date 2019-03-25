//
//  EliminarUsuarioViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 23/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import SQLite3

class EliminarUsuarioViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var db: OpaquePointer?
    var usuario = [Usuario]()
    var conexion = Conexion()
    var usu: [String] = []
    var usuSelect: String = ""

    @IBOutlet weak var tabla: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        conexion.conectarDB(nombreDB: "Datos.sqlite")
        conexion.crearObjUsuario()
        //leerValores()
        
        // Do any additional setup after loading the view.
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let celda = self.tabla.cellForRow(at: indexPath)
        let texto = (celda?.textLabel?.text)!
        usuSelect = texto
    }
    
    @IBAction func borrarUsu(_ sender: Any)
    {
        print(usuSelect)
        //if usuSelect != usuario.getUsuario() {
            conexion.eliminarUsuario(usu: usuSelect)
        //}
        //conexion.insertarUsuario(usu: "admin", pass: "admin", tipo: "A")
        //leerValores()
        conexion.crearObjUsuario()
        tabla.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //---------------------------------------------------------------------------------------------------------------
    //VISUALIZAR HISTORIAL EN TABLEVIEW
    //--------------------------------------------------------------------------------------------------------------
    //INDICAMOS EL NUMERO DE FILAS QUE TENDRA NUESTRA SECCIÓN A PARTIR DEL TOTAL DE OBJETOS QUE SE HABRAN CREADO GRACIAS A NUESTRA BASE DE DATOS
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return usuario.count
    }
    
    //IPOR CADA REGISTRO CREAMOS UNA LINEA Y LA RELLENAMOS CON LOS OBJETOS EXTRAIDOS DE LA BASE DE DATOS
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //INDICAMOS EL ESTILO DE LA CELDA Y EL IDENTIFICADOR DE ESTA
        //let celda = UITableViewCell(style: UITableViewCell.CellStyle.default,  reuseIdentifier: "celdilla")
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        
        //RECCOREMOS NUESTRA COLECCIÓN DE OBJETOS Y GUARDAMOS LA URL DE NUESTRO HISTORIAL EN UNA COLECCION DE STRINGS PARA PODER RELLENAR LAS CELDAS A CONTINUACION
        for us in usuario
        {
            usu.append(us.usuario)//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
        }
        //RELLENAMOS LAS CELDAS CON NUESTRA NUEVA COLECCION
        celda.textLabel?.text = usu[indexPath.row]//LE INDICAMOS QUE LOS INSERTE SEGUN EL INDICE DE FILAS QUE CREAMOS EN LA FUNCION ANTERIOR CON "historial.count"
        //CARGAMOS LAS CELDAS
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
