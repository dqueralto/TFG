//
//  ContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 04/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit

class ContenidoViewController: UIViewController {
 
    
    var usuario: String?
    internal var cabecera: String? 
    
    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var menu: UIView!
    
    @IBAction func menu(_ sender: Any)
    {
        menu.isHidden = false
    }
    
    @IBAction func cerrar(_ sender: Any)
    {
        menu.isHidden = true

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cabecera = self.usuario!
        titulo.title = cabecera
    }

    //---------------------------------------------------------------------------------------------------------
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
    

}
