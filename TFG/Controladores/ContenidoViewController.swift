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
//import Firebase

class ContenidoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var usuario: String?
    internal var cabecera: String? 
    
    @IBOutlet weak var titulo: UINavigationItem!
    @IBOutlet weak var selector: UISegmentedControl!
    
    @IBOutlet weak var conversor: UIView!
    @IBOutlet weak var gestor: UIView!
    
    @IBOutlet weak var histoConver: UITableView!
    @IBOutlet weak var histoGestor: UITableView!

    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var resultado: UILabel!
    @IBOutlet weak var valorRegistro: UITextField!
    @IBOutlet weak public var totalRegistro: UILabel!
    
    @IBOutlet weak var pickerOrigen: UIPickerView!
    @IBOutlet weak var pickerDestino: UIPickerView!
    
    var codDivOri: String = ""
    var codDivDes: String = ""
    var posVal: Int = 0
    var posRes: Int = 0
    
    private var db: OpaquePointer?
    private var movimientos = [Movimientos]()
    private var mov: [String] = []
    
    let fecha = Funciones().fechaActual()

    var resulConversion: String = "0"
    var insertHisto:Bool = false
    var total = "nil"
    override func viewDidLoad() {
        super.viewDidLoad()
        valor.delegate = self
        valorRegistro.delegate = self
        
        pickerOrigen.delegate = self
        pickerOrigen.dataSource = self
        pickerDestino.delegate = self
        self.pickerDestino.dataSource = self
        
        
        
        
        DispatchQueue.global(qos: .background).async {//hilo de fondo
            print("Esto se ejecuta en la cola de fondo")
            
            self.cabecera = self.usuario!
            self.titulo.title = self.cabecera
            
            self.total = ConexionDB().listenDocumentoMas(coleccion: "Movimientos", documento: self.cabecera!, importe: "0")
            
            DispatchQueue.main.async {//hilo principal
                print("Esto se ejecuta en la cola principal, después del código anterior en el bloque externo")
                
                self.controlConexion()
                
                
            }//fin hilo de principal
        }//fin del hilo de fondo
        
    }
    
    internal func controlConexion(){
        if Funciones().tengoConexion(){
            self.conversor.isHidden = true
            self.gestor.isHidden = false
            self.selector.isHidden = false
            self.total = self.total+" €"
            self.totalRegistro.text = self.total
        }else{
            self.conversor.isHidden = false
            self.gestor.isHidden = true
            self.selector.isHidden = true
        }
        
    }
    
    @IBAction func ventanas(_ sender: Any) {
        switch selector.selectedSegmentIndex
        {
            case 0:
                if Funciones().tengoConexion(){
                    NSLog("Gestor selected")
                    self.conversor.isHidden = true
                    self.gestor.isHidden = false
                    self.valor.text = "0"
                }else{
                    self.controlConexion()
                    Alertas().alertaSinConexion(donde: self)
                }

            //show movimientos view
            
            case 1:
                if Funciones().tengoConexion(){
                    NSLog("Conversor selected")
                    self.conversor.isHidden = false
                    self.gestor.isHidden = true
                    self.valorRegistro.text = "0"
                }else{
                    self.controlConexion()
                    Alertas().alertaSinConexion(donde: self)
                }
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

        
        if textField == self.valor||textField == self.valorRegistro {
            switch string {
                
            case "0","1","2","3","4","5","6","7","8","9":
                return true
            case ",":
                var array = Array("")
                if textField == self.valor{
                    array = Array(self.valor.text!)
                }else if textField == self.valorRegistro {
                    array = Array(self.valorRegistro.text!)
                }
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
        Alertas().crearAlertainformacion(titulo: "Info:", mensaje: "Esta seccion solo estara habilitada si dispone de conexión a internet. \n\nEl al insertar una cantidad puedes elegir ente registrarlo como un valor positivo (+) en cullo caso se sumara al total o por el contrario insertarlo como un valor negativo (-) en cuyo caso se restara al total. \n\nEsta permitido que el total sea negativo lo que implica que se esta perdiendo dinero, tenga cuidado con eso...", vc: self )
    }


    @IBAction func sumar(_ sender: Any)
    {
        if Funciones().tengoConexion(){
            let importe = Funciones().cambioCaracteres(texto: valorRegistro.text!, de: ",", a: ".")
            
            DispatchQueue.global(qos: .background).async {//hilo de fondo
                print("Esto se ejecuta en la cola de fondo")
                //var
                if Funciones().tengoConexion(){
                    self.total = ConexionDB().listenDocumentoMas(coleccion: "Movimientos", documento: self.cabecera!, importe: importe)
                }
                
                DispatchQueue.main.async {//hilo principal
                    
                    self.total = self.total+" €"
                    self.totalRegistro.text = Funciones().cambioCaracteres(texto: self.total, de: ".", a: ",")
                    self.histoGes.append("Ingreso Registrado: +\(self.valorRegistro.text!) €")
                    self.histoGestiones.removeAll()
                    self.histoGestor.reloadData()
                    self.valorRegistro.text = ""
                    
                }
            }
            
        }else{
            
            self.controlConexion()
            Alertas().alertaSinConexion(donde: self)
        }

    }
    
    @IBAction func restar(_ sender: Any)
    {
        if Funciones().tengoConexion(){
            let importe = Funciones().cambioCaracteres(texto: valorRegistro.text!, de: ",", a: ".")
            
            DispatchQueue.global(qos: .background).async {//hilo de fondo
                print("Esto se ejecuta en la cola de fondo")
                //var
                if Funciones().tengoConexion(){
                    self.total = ConexionDB().listenDocumentoMenos(coleccion: "Movimientos", documento: self.cabecera!, importe: importe)
                }
                DispatchQueue.main.async {//hilo principal
                    
                    self.total = self.total+" €"
                    self.totalRegistro.text = Funciones().cambioCaracteres(texto: self.total, de: ".", a: ",")

                    self.histoGes.append("Gasto Registrado: -\(self.valorRegistro.text!) €")
                    self.histoGestiones.removeAll()
                    self.histoGestor.reloadData()
                    self.valorRegistro.text = ""
                }
            }
            
        }else{
            self.controlConexion()
            Alertas().alertaSinConexion(donde: self)
        }
    }

//------------------------------------------------------botones de "Conversor"------------------------------------------------------
    @IBAction func limpiarConvertidor(_ sender: Any)
    {
        
        self.valor.text = "0"
        self.resultado.text = "0"
    }
    
    
    @IBAction func convertir(_ sender: Any)
    {
        
        if Funciones().tengoConexion(){
            if Funciones().tengoConexion(){
                self.selector.selectedSegmentIndex = 1
                self.selector.isHidden = false
                
            }
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
            self.valor.text = "0"
        }
        else if   array[0] == ","
        {
            if array[0] == "," && array.count == 1
            {
                self.valor.text = "0"
            }
            else if array[0] == "," && array.count > 1
            {
                let intermedia = self.valor.text!
                self.valor.text = "0"+intermedia
            }
        }
        else if array[0] == "0"  && array.count == 1
        {
            self.valor.text = "0"
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
                //self.conver.append(Conversiones(valOri: self.valor.text!, divOri: self.codDivOri, valCon: self.resulConversion, divCon: self.codDivDes))
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
            self.valor.text = "0"
        }
        else if   array[0] == ","
        {
            if array[0] == "," && array.count == 1
            {
                self.valor.text = "0"
            }
            else if array[0] == "," && array.count > 1
            {
                let intermedia = self.valor.text!
                self.valor.text = "0"+intermedia
            }
        }
        else if array[0] == "0"  && array.count == 1
        {
            self.valor.text = "0"
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
                
                self.valor.text = "0"
                self.resultado.text = "0"
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
    var histoGestiones: [String] = []
    var histoGes: [String] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == histoConver {
            return conver.count
        }else{
            return histoGes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let celda = tableView.dequeueReusableCell(withIdentifier: "celdilla", for: indexPath)
        if tableView == histoConver{
            print("histoConver")
            for con in conver.reversed()
            {
                conversiones.append("\(con.valOri) \(con.divOri)  =  \(con.valCon) \(con.divCon)")//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
            }
            celda.textLabel?.text = conversiones[indexPath.row]
            //PARA QUE CADA TABLA TENGA UNA CONFIGURACION DISTINTA SE ESPECIFICA AQUI Y SE QUITA LA GENERICA
            //celda.textLabel?.textAlignment = .center
            //celda.textLabel?.textColor = UIColor.white //CAMBIAMOS EL COLOR DE LAS LETRAS DE LA LISTA

        }
        if tableView == histoGestor{
            print("histoGestor")
            for hg in histoGes.reversed()
            {
                histoGestiones.append("\(hg)")//AÑADIMOS EL ESTRING "URL" A LA NUEVA COLECCION
            }

            celda.textLabel?.text = histoGestiones[indexPath.row]
            //PARA QUE CADA TABLA TENGA UNA CONFIGURACION DISTINTA SE ESPECIFICA AQUI Y SE QUITA LA GENERICA

            //celda.textLabel?.textAlignment = .center
            //celda.textLabel?.textColor = UIColor.red //CAMBIAMOS EL COLOR DE LAS LETRAS DE LA LISTA

        }
        
        //celda.textLabel?.text = conversiones[indexPath.row]//LE INDICAMOS QUE LOS INSERTE SEGUN EL INDICE DE FILAS QUE CREAMOS EN LA FUNCION ANTERIOR CON "historial.count"
        celda.textLabel?.font = UIFont(name: "Georgia", size: 15) // CAMBIAMOS LA FUENTE Y EL TAMAÑO DE LAS TABLAS 
        celda.textLabel?.textAlignment = .center  //CENTRAMOS EL TEXTO DE LA LISTA
        celda.textLabel?.textColor = UIColor.white //CAMBIAMOS EL COLOR DE LAS LETRAS DE LA LISTA
            
        return celda
    }
    
    
    
    //_---------------------------------------------------------------------------------------------------------------
    
    
    
    
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


internal class Movimientos{
    var usuario: String
    var valor: Double
    var tipo: String
    
    
    init (usuario: String, valor: Double, tipo: String){
        self.usuario = usuario
        self.valor = valor
        self.tipo = tipo
    }
}
