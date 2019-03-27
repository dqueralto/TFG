//
//  Funciones.swift
//  TFG
//
//  Created by Daniel Queraltó Parra on 21/03/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//
import UIKit
import SystemConfiguration
import Foundation

internal class Funciones: UIViewController
{
    var usuarios = [Usuario]()
    
    

    
    //la siguiente funcion nos devuelve
    internal func tengoConexion() -> Bool {
    
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
    
    }



    

    //por ahora no uso esta clase
    internal func tipo_Usuario(usua: String, pass: String, confPass: String)
    {
        for usu in usuarios
        {
            //alerta.isHidden = true
            //alerta2.isHidden = true
            print("1")
            
            if usua.elementsEqual(usu.usuario)
            {
                print("2")
                if pass.elementsEqual(usu.contrasenia)
                {
                    print("3")
                    if usu.tipo.elementsEqual("A")//si el tipo del usuario introducido es "A"
                    {
                        print("3.1")
                        //performSegue(withIdentifier: "contenidoAdmin", sender: nil)//asignamos al segue el nombre de la ruta al view de los admin
                        return//finalizamos acciones
                        
                    }
                    else if usu.tipo.elementsEqual("U")//si el tipo del usuario introducido es "U"
                    {
                        print("3.2")
                        //performSegue(withIdentifier: "contenido", sender: nil)//asignamos al segue el nombre de la ruta al view de los usuarios
                        return//finalizamos acciones
                        
                    }
                }
                else
                {
                    print("4")
                    //alerta2.isHidden = false
                    //return
                }
            }
            else
            {
                print("5")
                //alerta.isHidden = false
                //return
            }
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
    
    

