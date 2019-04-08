//
//  ContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 04/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import Alamofire
class ContenidoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {
 
    
    var usuario: String?
    internal var cabecera: String? 
    
    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBOutlet weak var movimientos: UIView!
    @IBOutlet weak var conversor: UIView!
    
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var resultado: UILabel!
    
    @IBOutlet weak var pickerOrigen: UIPickerView!
    @IBOutlet weak var pickerDestino: UIPickerView!
    
    var codDivOri: String = ""
    var codDivDes: String = ""
    var posVal: Int = 0
    var posRes: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cabecera = self.usuario!
        titulo.title = cabecera
        
        self.valor.delegate = self
        pickerOrigen.delegate = self
        pickerOrigen.dataSource = self
        pickerDestino.delegate = self
        pickerDestino.dataSource = self
        
        self.movimientos.isHidden = false
        

        
        
        
    }
    
    
    @IBAction func ventanas(_ sender: Any) {
        switch selector.selectedSegmentIndex
        {
            case 0:
            NSLog("Movimientos selected")
            self.movimientos.isHidden = false
            self.conversor.isHidden = true
            //show movimientos view
            
            case 1:
            NSLog("Conversor selected")
            self.conversor.isHidden = false
            self.movimientos.isHidden = true
            //show historial view
            
            default:
            break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)//de esta forma selecciono el contenido del text field

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*let array = Array(self.valor.text!)
        if array[0] == ","
        {
            let intermedia = self.valor.text!
            self.valor.text = "0"+intermedia
        }*/
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        /*//agragar esto para controlar coma suelta
         
        let array = Array(self.valor.text!)
        if array[0] == ","
        {
            let intermedia = self.valor.text!
            self.valor.text = "0"+intermedia
        }
        */
        //For mobile numer validation
        if textField == self.valor {

            
            
            switch string {
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ",":
                let array = Array(self.valor.text!)
                var decimalCount = 0
                
                for character in array {
                    if character == "," {
                        decimalCount+=1
                    }
                }
                
                if decimalCount == 1 {
                    return false
                } else {
                    return true
                }
                
            default:
                let array = Array(string)
                if array.count == 0 {
                    return true
                }
                return false
                
            }
            
            

            
            
            /*
        let inverseSet = CharacterSet(charactersIn:"0123456789").inverted
        let components = string.components(separatedBy: inverseSet)
        let filtered = components.joined(separator: "")
        
        if filtered == string {
            return true
        } else {
            if string == "." || string == "," {
                let countDots = textField.text!.components(separatedBy:".").count - 1
                let countCommas = textField.text!.components(separatedBy:",").count - 1
                
                if countDots == 0 && countCommas == 0 {
                    return true
                } else {
                    return false
                }
            } else  {
                return false
            }
        }
        
        
  
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789,.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
            */
            
            
        }

        
        
        return true
        
        
    }
//------------------------------------------------------botones de "Movimientos"------------------------------------------------------
    
    @IBAction func infoMovimiento(_ sender: Any)
    {
        Alertas().crearAlertainformacion(titulo: "Info:", mensaje: "Algo.", vc: self )
    }
    
    @IBAction func sumar(_ sender: Any)
    {
        
    }
    
    @IBAction func restar(_ sender: Any)
    {
        
    }
    
//------------------------------------------------------botones de "Conversor"------------------------------------------------------
    @IBAction func limpiarConvertidor(_ sender: Any)
    {
        self.valor.text = "0,0"
        self.resultado.text = "0,0"
    }
    /* @IBAction func convertir(_ sender: Any)
    {
        if(codDivDes == "" ){
            
            codDivDes = codDivisa[0]
        }
        if(codDivOri == "" ){
            
            codDivOri = codDivisa[0]
        }
            let url = "https://api.exchangeratesapi.io/latest?base="+self.codDivOri.uppercased()
            print("val1: "+self.codDivOri.uppercased())
            print("val2: "+self.codDivDes.uppercased())
            Alamofire.request(url,method: .get).responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    var cambio: Double = 0.0
                    
                    cambio = JSON["rates"]![self.codDivDes.uppercased()]!! as! Double
                    var valor = self.valor.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                    if valor.count != 0{
                        
                        valor = valor.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                        var paso:Double=0.0
                        
                        paso = (Double(valor) as! Double)
                        
                        var fin: Double = 0.0
                        
                        fin = Funciones().calcularConversion(cantidad: paso,cambio: cambio)

                        print("uffff")
                        self.resultado.text = String(fin)
                    }
                    else
                    {
                        Alertas().crearAlertainformacion(titulo: "Cuidadin", mensaje: "No a introducido una cantidad que convertir...",vc: self)
                    }
                    
                }
                
            }

    }*/
    
    @IBAction func convertir(_ sender: Any)
    {
        harcoreConverter()
    }
    @IBAction func infoConversion(_ sender: Any)
    {
        Alertas().crearAlertainformacion(titulo: "Info:", mensaje: "Los cambios entre divisas se realizan tanto al seleccionar una divisa como al pulsar el botón 'Convertir'.\n \nEl botón con flechas invierte los valores y las divisas .", vc: self )
    }
    
    func harcoreConverter()
    {
        
        let array = Array(self.valor.text!)
        let str = self.valor.text!
        print(array.count)

        //let comienzo = str.firstIndex(of: ",")!
        //let antesDeLaComa = str[...comienzo]
        
        if self.valor.text!.count == 0
        {
            self.valor.text = "0,0"
        }
        else if   array[0] == ","
        {
            if array[0] == "," && array.count == 1
            {
                self.valor.text = "0,0"
            }
            else if array[0] == "," && array.count > 1 //|| array[1] == ","
            {
                let intermedia = self.valor.text!
                self.valor.text = "0"+intermedia
            }
        }
        else if array[0] == "0"  && array.count == 1
        {
            self.valor.text = "0,0"
        }
        else if  array[1] == "," && array[0] == "0" && array.count == 2
        {
            self.valor.text = "0,0"
        }
        

        if(codDivDes == "" ){
            
            codDivDes = codDivisa[0]
        }
        
        if(codDivOri == "" ){
            
            codDivOri = codDivisa[0]
        }
        let url = "https://api.exchangeratesapi.io/latest?base="+self.codDivOri.uppercased()
        print("val1: "+self.codDivOri.uppercased())
        print("val2: "+self.codDivDes.uppercased())
        
        if codDivOri != codDivDes{
            Alamofire.request(url,method: .get).responseJSON { response in
                if let JSON = response.result.value as? [String:AnyObject] {
                    var cambio: Double = 0.0
                    
                    cambio = JSON["rates"]![self.codDivDes.uppercased()]!! as! Double
                    var valor = self.valor.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                    if valor.count != 0{
                        valor = Funciones().cambioCaracteres(texto: valor, de: ",", a: ".")
                        //valor = valor.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
                        var paso:Double=0.0
                        
                        paso = (Double(valor) as! Double)
                        var fin: Double = 0.0
                        
                        fin = Funciones().calcularConversion(cantidad: paso,cambio: cambio)
                        print("uffff")
                        self.resultado.text = Funciones().cambioCaracteres(texto: String(fin), de: ".", a: ",")
                        
                    }
                    else
                    {
                        Alertas().crearAlertainformacion(titulo: "Cuidadin", mensaje: "No a introducido una cantidad que convertir...",vc: self)
                    }
                    
                }
                
            }
        }
        else
        {
            self.resultado.text = self.valor.text!
        }
            
        
    }
    
    @IBAction func intercambiar(_ sender: Any)
    {
        if codDivOri != codDivDes
        {
            let valor = self.valor.text!
            let resultado = self.resultado.text!
            self.valor.text = resultado
            self.resultado.text = valor
            self.pickerOrigen.selectRow(self.posRes, inComponent: 0, animated: true)
            self.pickerDestino.selectRow(self.posVal, inComponent: 0, animated: true)
            
            let intermedia = self.posVal
            self.posVal = self.posRes
            self.posRes = intermedia
            
            let intermediaDos = codDivOri
            codDivOri = codDivDes
            codDivDes = intermediaDos
            
            
            harcoreConverter()
        }
        else
        {
            if(self.valor.text! == "," ){
                
                self.valor.text = "0,0"
                self.resultado.text = "0,0"
            }
            self.resultado.text = self.valor.text!
        }
        
    }
//------------------------------------------------------------------------------------------------------------------------------------
    let codDivisa = ["AUD","BGN","BRL","CAD","CHF","CNY","CZK","DKK","EUR","GBP","HKD","HRK","HUF","IDR","ILS","INR","ISK","JPY","KRW","MXN","MYR","NOK","NZD","PHP","PLN","RON","RUB","SEK","SGD","THB","TRY","USD","ZAR"]
    //LE INDICAMOS QUE CUANDO TOQUEMOS EN ALGUNA PARTE DE LA VISTA CIERRE EL TECLADO
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    //---------------------------------------------------------------------------------------------------------
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
        return codDivisa.count
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return codDivisa[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
                           
        if pickerView == pickerOrigen {
            
            self.codDivOri = codDivisa[row]
            print(row)
            self.posVal = row
            print(self.posVal)
            harcoreConverter()
            
        } else if pickerView == pickerDestino{
            self.codDivDes = codDivisa[row]
            print(row)
            self.posRes = row
            print(self.posRes)
            harcoreConverter()
        }
        
        

        

        
        
    }
    //---------------------------------------------------------------------------------------------------------

}
