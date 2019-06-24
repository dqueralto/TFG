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
import Alamofire

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
    
    internal func compararContenidos(contHisto contUno:String, contConver contDos:String) -> Bool
    {
        
        var iguales:Bool = false
        
        if contUno.elementsEqual(contDos)
        {
            iguales = true
        }
        else if !contUno.elementsEqual(contDos)
        {
            iguales = false
        }
        
        return iguales
        
    }
    
    internal func fechaActual() -> String
    {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        //let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        //formatter.dateFormat = "dd-MMM-yyyy"
        // again convert your date to string
        //let myStringafd = formatter.string(from: yourDate!)
        return myString
    }
    
    internal func singup(with email: String, and password: String, onComplete: Completion?) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error != nil {
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
            } else {
                onComplete?(nil, user)
            }
            
        }
    }
    
    internal func handleFirebaseError(error: NSError, onComplete: Completion?) {
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

    internal func cambioCaracteres(texto:String, de:String, a: String) -> String {
        let cambio = texto.replacingOccurrences(of: de, with: a, options: .literal, range: nil)
        return cambio
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
    
    internal func reglaDeTres(cambio: Double, deseado: Double) -> Double
    {
        var resultado:Double = 0.0
        resultado = ((1*cambio)/deseado)
        return resultado
        
    }

    
    internal func calcularConversion(cantidad:Double, cambio:Double)->Double
    {
        
        var conversion:Double = 0.0
        conversion = cantidad*cambio

        let text = String(format: "%.5f", arguments: [conversion])


        return Double(text) as! Double
        
    }
    

    
    
    //------------------------------------------------------------------------------------------------------
    internal func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //------------------Conexion API----------------------------------------------------------------------------

     internal func obtenerCambio(divOri:String, divDes:String) ->Double
    {
        let url = "https://api.exchangeratesapi.io/latest?base="+divOri
        var cambio:Double = 0.0

        
        Alamofire.request(url,method: .get).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                cambio = JSON["rates"]![divDes]!! as! Double

            }
            
        }
        //print(cambio)
        return cambio
        
    }
    
    internal func obtenerCambioDelJSON(divOri:String, divDes:String) ->Double
    {
        //let url = "https://api.exchangeratesapi.io/latest?base="+divOri
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("cambios.JSON.json")
        if let ruta = Bundle.main.path(forResource: "cambios.JSON.", ofType: "JSON"),
            let datosJSON = FileManager.default.contents(atPath: ruta),
            let _ = try? JSONSerialization.jsonObject(with: datosJSON, options: .mutableContainers) as? [[String:Any]] {
        }
        var cambio:Double = 0.0
        print(divDes)
        Alamofire.request(fileURL,method: .get).responseJSON { response in
            if let JSON = response.result.value as? [String:AnyObject] {
                cambio = JSON["rates"]![divDes]!! as! Double
                print(fileURL)
                print(divOri)
                print(cambio)
                print(divOri)
                print(divDes)
            }
        }
        print(cambio)
        return cambio
    }
    
    internal func escribirFichero(text tx:String) {//este metodo escribe el json en un fichero fisico
        
        let dir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create:true)
        let file = dir.appendingPathComponent("cambios.JSON")
        let cadena = tx as! String
        do{
            try cadena.write(to: file, atomically: true, encoding: String.Encoding.utf8)
        }
        catch {}

    }
    
    
    internal func leerFichero() -> String {//este metodo lee el fichero fisico y retorna su contenido en un string
        var fichText:String = ""
        let directorio = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let file = directorio.appendingPathComponent("cambios.JSON")
        do{
            let datosGuardados = try String(contentsOf: file, encoding: String.Encoding.utf8)
            fichText = datosGuardados
        }
        catch{}
        
        return fichText
    }
}


    
    



