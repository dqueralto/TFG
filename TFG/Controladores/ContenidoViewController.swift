//
//  ContenidoViewController.swift
//  PracticaFinalSwift
//
//  Created by Daniel Queraltó Parra on 04/02/2019.
//  Copyright © 2019 Daniel Queraltó Parra. All rights reserved.
//

import UIKit
import Alamofire
import SQLite3

class ContenidoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {

    var usuario: String?
    internal var cabecera: String? 
    
    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBOutlet weak var conversor: UIView!
    
    @IBOutlet weak var histoConver: UITableView!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var resultado: UILabel!
    
    @IBOutlet weak var pickerOrigen: UIPickerView!
    @IBOutlet weak var pickerDestino: UIPickerView!
    
    var codDivOri: String = ""
    var codDivDes: String = ""
    var posVal: Int = 0
    var posRes: Int = 0

    var resulConversion: String = "0,0"
    var insertHisto:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //cabecera = self.usuario!
        titulo.title = cabecera
        
        self.valor.delegate = self
        pickerOrigen.delegate = self
        pickerOrigen.dataSource = self
        pickerDestino.delegate = self
        pickerDestino.dataSource = self
        
    }
    

    
    @IBAction func ventanas(_ sender: Any) {
        switch selector.selectedSegmentIndex
        {
            case 0:
            NSLog("Movimientos selected")
            self.conversor.isHidden = true
            //show movimientos view
            
            case 1:
            NSLog("Conversor selected")
            self.conversor.isHidden = false
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

    }
    

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

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
    
    
    @IBAction func convertir(_ sender: Any)
    {
        
        if Funciones().tengoConexion(){
            
            if !codDivDes.elementsEqual(codDivOri)
            {
                self.insertHisto = true
            }
            self.conversionConAPI()
                

        }
        else
        {

            conversionSinAPI()
            
            self.conver.append(Conversiones(valOri: self.valor.text!, divOri: self.codDivOri, valCon: self.resultado.text!, divCon: self.codDivDes))
            
            self.conversiones.removeAll()
            self.histoConver.reloadData()
        }
        
        
        
        
    }
    
    @IBAction func infoConversion(_ sender: Any)
    {
        Alertas().crearAlertainformacion(titulo: "Info:", mensaje: "Los cambios entre divisas se realizan tanto al seleccionar una divisa como al pulsar el botón 'Convertir', como funcion extra al pulsar este botón se dicha conversión se almacenara en un pequeño historial temporal que se eliminara al salir del usuario y/o cerrar la aplicación.\n \nEl botón con flechas invierte los valores y las divisas.", vc: self )
    }


    func conversionSinAPI()
    {

        
        let array = Array(self.valor.text!)
        let str = self.valor.text!
        print(array.count)
        
        
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
            else if array[0] == "," && array.count > 1
            {
                let intermedia = self.valor.text!
                self.valor.text = "0"+intermedia
            }
        }
        else if array[0] == "0"  && array.count == 1
        {
            self.valor.text = "0,0"
        }
        
        
        if(codDivDes == "" ){
            
            codDivDes = codDivisa[0]
        }
        
        if(codDivOri == "" ){
            
            codDivOri = codDivisa[0]
        }
        
        var json:String = ""
        
        
        let yourJSONString: String = """
{"base":"GBP","rates":{"BGN":2.2552264105,"NZD":1.9667216309,"ILS":4.6293370847,"RUB":84.4186663284,"CAD":1.7431361922,"USD":1.2944662892,"PHP":67.9150859634,"CHF":1.303806372,"AUD":1.8636347912,"JPY":141.8308868466,"TRY":7.810154169,"HKD":10.1601651234,"MYR":5.398567854,"HRK":8.5459451357,"CZK":29.6933916032,"IDR":18679.1508596335,"DKK":8.6125941215,"NOK":11.2991939854,"HUF":373.868523921,"GBP":1.0,"MXN":24.8121029023,"THB":40.7758034201,"ISK":158.8967171339,"ZAR":18.4202576018,"BRL":5.159300301,"SGD":1.7718482986,"PLN":4.9653494459,"INR":91.1378757654,"KRW":1537.3084418205,"RON":5.4904696563,"CNY":8.9079021713,"SEK":12.4292286937,"EUR":1.153096641},"date":"2019-05-14"}
"""
        
        
        if let ruta = Bundle.main.path(forResource: "ChangesBaseUSD", ofType: "json"),
            let datosJSON = FileManager.default.contents(atPath: ruta),
            let datos = try? JSONSerialization.jsonObject(with: datosJSON, options: .mutableContainers) as? String {
            json = datos
        }
        struct  Divisa:Codable
        {
            let base: String
            let rates: [String: Double]
            let date: String
        }
        
        let jsonDecoder: JSONDecoder = JSONDecoder();
        
        // Decode by telling it which struct or class maps to which String containing JSON.
        do {
            let divisa: Divisa = try jsonDecoder.decode(Divisa.self, from: yourJSONString.data(using: String.Encoding.utf8)!);

            print(divisa.rates["GBP"]) // "bar"
            
            
            
            if codDivOri != codDivDes{
                
                
                var cambioOrigen: Double = 0.0
                var cambioDestino: Double = 0.0
                var cambio: Double = 0.0

                
                
                var valor = self.valor.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
                
                if valor.count != 0{
                    valor = Funciones().cambioCaracteres(texto: valor, de: ",", a: ".")
                    var paso:Double = 0.0
                    var fin: Double = 0.0
                    paso = (Double(valor) as! Double)
                    
                    cambioOrigen = divisa.rates[codDivOri]!


                    cambioDestino = divisa.rates[codDivDes]!

                    
                    fin = Funciones().reglaDeTres(cambio: cambioDestino, deseado: cambioOrigen)

                    
                    fin = Funciones().calcularConversion(cantidad: paso,cambio: fin)


                    self.resultado.text = Funciones().cambioCaracteres(texto: String(fin), de: ".", a: ",")
                    
                    
                    fin = 0
                    
                    
                }
                else
                {
                    Alertas().crearAlertainformacion(titulo: "Cuidadin", mensaje: "No a introducido una cantidad que convertir...",vc: self)
                }
                
            }
            else
            {
                self.resultado.text = self.valor.text!
                self.conver.append(Conversiones(valOri: self.valor.text!, divOri: self.codDivOri, valCon: self.resulConversion, divCon: self.codDivDes))
                self.conversiones.removeAll()
                
                self.histoConver.reloadData()
            }
            
        } catch {
            // Handle if the JSON cannot map to the struct or class.
        }
        

        
        
    }
    func conversionConAPI()
    {
        
        let array = Array(self.valor.text!)
        let str = self.valor.text!
        print(array.count)

        
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
            else if array[0] == "," && array.count > 1
            {
                let intermedia = self.valor.text!
                self.valor.text = "0"+intermedia
            }
        }
        else if array[0] == "0"  && array.count == 1
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
                        var paso:Double=0.0
                        
                        paso = (Double(valor) as! Double)
                        var fin: Double = 0.0
                        
                        fin = Funciones().calcularConversion(cantidad: paso,cambio: cambio)
                       
                        self.resulConversion = Funciones().cambioCaracteres(texto: String(fin), de: ".", a: ",")
                        self.resultado.text = self.resulConversion
                        
                        
                        if self.insertHisto{
                            self.conver.append(Conversiones(valOri: self.valor.text!, divOri: self.codDivOri, valCon: self.resulConversion, divCon: self.codDivDes))
                            self.conversiones.removeAll()
                            
                            self.histoConver.reloadData()
                            self.insertHisto = false
                        }
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
            if self.insertHisto{
                self.resultado.text = self.valor.text!
                self.conver.append(Conversiones(valOri: self.valor.text!, divOri: self.codDivOri, valCon: self.resulConversion, divCon: self.codDivDes))
                self.conversiones.removeAll()
                
                self.histoConver.reloadData()
                self.insertHisto = false
            }
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
    
    // numero de columnas de datos
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    //  numero de filas de datos
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return codDivisa.count
    }
    
    
    // The data to return fopr the row and component (column) that's being passed in
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return codDivisa[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let titleData = codDivisa[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [.font:UIFont(name: "Georgia", size: 15.0)!, .foregroundColor:UIColor.white])
        return myTitle
    }
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
                           
        if pickerView == pickerOrigen {
            
            self.codDivOri = codDivisa[row]
            print(row)
            self.posVal = row
            print(self.posVal)
            
            
        }else if pickerView == pickerDestino{
            self.codDivDes = codDivisa[row]
            print(row)
            self.posRes = row
            print(self.posRes)
  
            
        }
        
        
        if Funciones().tengoConexion(){
            conversionConAPI()
        }else if !Funciones().tengoConexion(){
            conversionSinAPI()
        }

    }
    //---------------------------------------------------------------------------------------------------------
    

    
    
//---------HISTORIAL DE CONVERSION ------------------------------------------------------------------------------------------------
    var conversiones: [String] = []
    var conver = [Conversiones]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conver.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        
        for con in conver.reversed()
        {
            conversiones.append("\(con.valOri) \(con.divOri)  =  \(con.valCon) \(con.divCon)")//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
        }
        
        celda.textLabel?.text = conversiones[indexPath.row]//LE INDICAMOS QUE LOS INSERTE SEGUN EL INDICE DE FILAS QUE CREAMOS EN LA FUNCION ANTERIOR CON "historial.count"

        celda.textLabel?.textAlignment = .center  //CENTRAMOS EL TEXTO DE LA LISTA
        celda.textLabel?.textColor = UIColor.white //CAMBIAMOS EL COLOR DE LAS LETRAS DE LA LISTA
        return celda
    }
//---------------------------------------------------------------------------------------------------------

}

internal class Conversiones{
        var valOri: String
        var divOri: String
        var valCon: String
        var divCon: String


    init (valOri: String, divOri: String, valCon: String, divCon: String){
        self.valOri = valOri
        self.divOri = divOri
        self.valCon = valCon
        self.divCon = divCon
    }
}
