//
//  LocalizarRestauranteVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 21/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import TextFieldEffects
import SVProgressHUD
import CoreLocation
import Firebase

class LocalizarRestauranteVC: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelRefrescar: UILabel!
    @IBOutlet weak var btnRefrescar: UIButton!
    @IBOutlet weak var viewComponentes: UIView!
    @IBOutlet weak var textFieldRestaurante: IsaoTextField!
    
    var pickerView = UIPickerView()
    
    private let locationManager = CLLocationManager()
    
    let DBProv = DBReference()
    let DatosLocalizar = DatosLocalizarRestaurante()
    

    var restaurantesAMostrar = [String]()
    var userLocation : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Medium", size: 21)!,
                                                                        NSAttributedStringKey.foregroundColor:UIColor.white]
        
        labelRefrescar.alpha = 0
        viewComponentes.alpha = 0
        btnRefrescar.alpha = 0
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        textFieldRestaurante.inputView = pickerView
        createToolBar()
        
        pickerView.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        
        empezarConfigLocalizacion()
        
        validarRestaurantes()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textFieldRestaurante.text = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        
        aparecerComponentes()
        
    }
    
    
    //MARK: - Funciones y config. del Toolbar
    
    func createToolBar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        toolBar.isTranslucent = false
        toolBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let doneBtn = UIBarButtonItem(title: "Ok", style: .done, target: self, action: #selector(LocalizarRestauranteVC.okeyBtn))
        doneBtn.tintColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        
        toolBar.setItems([doneBtn], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        textFieldRestaurante.inputAccessoryView = toolBar
        
    }
    
    @objc func okeyBtn(){
        
        view.endEditing(true)
        
    }
    
   //----------------------------------------------------------------------------------------
    
    
    
    //MARK: - Botones en el VC
    
    @IBAction func btnIrMenu(_ sender: Any)
    {
        
        if textFieldRestaurante.text != "" {
            
            Database.database().reference().removeAllObservers()
            performSegue(withIdentifier: "segueSeleccionarRestaurante-Menu", sender: nil)
            
        }else{
            
            SVProgressHUD.showInfo(withStatus: "Seleccionar un restaurante")
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? SeccionesVC {
            
            destination.restauranteSeleccionado = textFieldRestaurante.text
            
        }
        
    }
    
    
    @IBAction func btnRefrescar(_ sender: Any) {
        
        SVProgressHUD.show(withStatus: "Actualizando restaurantes cercanos...")
        
        //
        
        Database.database().reference().removeAllObservers()
        
        restaurantesAMostrar.removeAll()
        
        textFieldRestaurante.text = ""
        
        validarRestaurantes()
        
        pickerView.reloadAllComponents()
        
        //
        
        SVProgressHUD.dismiss(withDelay: 2, completion: nil)
        
    }
    
    
    //---------------------------------------------------------------------------------
    
    
    
    //MARK: - Funciones para localizar
    
    func empezarConfigLocalizacion() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = self.locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            //Aqui tenemos que hacer las comparaciones a la hora que si se acerca a las localizaciones de algunos restaurantes
            
            //
            
            //print("Usuario coordenadas : latitud: \(userLocation.latitude) y longitud: \(userLocation.longitude)")
            
            
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Falló al localizar tus coords, \(error.localizedDescription)")
    }
    
    //------------------------------------------------------------------------------------------------
    
  
    func validarRestaurantes(){
        
        Database.database().reference().child("restaurantes").observe(.childAdded) { (snapshot) in
            
            let keys = [snapshot.key]
            
            for key in keys {
                
                if let dic = snapshot.value as? [String:Any] {
                    
                    let latitud = dic["Latitud"] as? Double
                    let longitud = dic["Longitud"] as? Double
                    
                    let locationRestaurante = CLLocation(latitude: latitud!, longitude: longitud!)
                    
                    //Arreglar que se pase los datos del usuario de su localizacion
                    let location2DUser = self.userLocation
                    print(self.userLocation?.latitude as Any, self.userLocation?.longitude as Any)
                    let lat = location2DUser?.latitude
                    let long = location2DUser?.longitude
                    
                    let locationUser = CLLocation(latitude: lat!, longitude: long!)
                    
                    let distancia = locationRestaurante.distance(from: locationUser) / 100 //A metros
                    
                    print("La distancia de las coordenadas del usuario y del restaurante \(key) es de: \(distancia.rounded())")
                    
                    //if distancia < 1 { //1 metro
                        
                        //Aparecer los restaurantes y agregarlos al Array
                        print("Se entró al if si esta cerca un restaurante, se agregará el restaurante \(key)")
                        self.restaurantesAMostrar.append(key)
                        print(self.restaurantesAMostrar)
                        
                    //}else{
                        //print("No se entró a la comparativa")
                   // }
                    
                }
                
            }
            
        }
    
        
    }
    
    @IBAction func prepareUnwindLocalizarRestauranteVC (segue:UIStoryboardSegue){
        
    }
    
    //MARK: - Funciones de animaciones de componentes
    
    func aparecerComponentes() {
        

        
        UIView.animate(withDuration: 1) {
            self.viewComponentes.alpha = 1
            self.aparecerLabel()
        }
        
    }
    
    func aparecerLabel() {
        
        UIView.animate(withDuration: 1) {
            self.labelRefrescar.alpha = 1
            self.aparecerBtnRefrescar()
        }
        
    }
    
    func aparecerBtnRefrescar() {
        
        UIView.animate(withDuration: 1) {
            self.btnRefrescar.alpha = 1
        }
        
    }
    
    //----------------------------------------------------------------------
    
    
    
    
    
}



extension LocalizarRestauranteVC: UIPickerViewDelegate, UIPickerViewDataSource {
   
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (restaurantesAMostrar.count)
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return restaurantesAMostrar[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        textFieldRestaurante.text = restaurantesAMostrar[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label:UILabel
        
        if let view = view as? UILabel {
            label = view
        }else{
            label = UILabel()
        }
        
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment =  .center
        label.font = UIFont(name: "Avenir-Medium", size: 24)
        
        label.text = restaurantesAMostrar[row]
        
        return label
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    
    
}

























