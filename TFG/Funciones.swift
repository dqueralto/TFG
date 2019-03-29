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
import FirebaseAuth

internal class Funciones{
    internal var alerta = Alertas()
    var usuarios = [Usuario]()
    
    
    //----------------------------------Conexion a Internet----------------------------------

    
    //la siguiente funcion nos devuelve si tenemos conexion a interner (Wifi o Datos) mediante un true/false
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
    //------------------------------------------------------------------------------------------
    internal func comprobarConexion(donde: UIViewController){//comprobamos si tenemos conexion a internet
        if !tengoConexion() {//en caso negativo
            alerta.alertaSinConexion(donde: donde)//mostramos alerta de informacion
        }
    }
    
    internal func comprobarUsuarioFirebase(usu:String) //-> Bool//
    {

    }

    func singup(with email: String, and password: String, onComplete: Completion?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                onComplete?(nil, user)
            }
            
        }
    }
    
    func handleFirebaseError(error: NSError, onComplete: Completion?) {
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch errorCode {
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            case .userNotFound:
                onComplete?("Correct you email or sign up if you not have an account", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
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
    
    //----------------------------------Calculos matematicos----------------------------------
    
    internal func claculoSuma(valUno: Double, valDos: Double ) -> Double
    {
        let total:Double = valUno+valDos
        return total
    }
    
    internal func claculoResta(valUno: Double, valDos: Double ) -> Double
    {
        let total:Double = valUno-valDos
        return total
    }
    
    
    internal func claculoMultiplicacion(valUno: Double, valDos: Double ) -> Double
    {
        let total:Double = valUno*valDos
        return total
    }
    
    internal func claculoDivision(valUno: Double, valDos: Double ) -> Double
    {
        let total:Double = valUno/valDos
        return total
    }
    
    
    //------------------------------------------------------------------------------------------
    internal func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    
    
}
    
    

