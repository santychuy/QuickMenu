//
//  MapaDireccionRestauranteVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 23/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class MapaDireccionRestauranteVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapaRestaurante: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    
    
    var restauranteLocalizacion = CLLocationCoordinate2D()
    let pinRestaurante = MKPointAnnotation()
    
    var restauranteSeleccionado:String?
    var categoriaSeleccionada:String?
    var latitudRest:Double?
    var longitudRest:Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavBar()
        empezarConfigLocalizacion()
        configLocalizacionRestaurante()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func configNavBar(){
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        
        navigationItem.title = "Localización"
        
    }
    
    func empezarConfigLocalizacion() {
        
        mapaRestaurante.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        locationManager.requestWhenInUseAuthorization()
        
        mapaRestaurante.isZoomEnabled = true
        mapaRestaurante.isPitchEnabled = true
        mapaRestaurante.isScrollEnabled = true
        
        mapaRestaurante.userLocation.title = nil
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = self.locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Falló al localizar tus coords, \(error.localizedDescription)")
    }
    
    
    func configLocalizacionRestaurante(){
        
        
        Database.database().reference().child("restaurantes").child("categorias").child(categoriaSeleccionada!).child(restauranteSeleccionado!).observeSingleEvent(of: .value) { (snapshot) in
            
            if let dicCoords = snapshot.value as? [String:Any]{
                
                self.latitudRest = dicCoords["Latitud"] as? Double
                print(self.latitudRest!)
                self.longitudRest = dicCoords["Longitud"] as? Double
                print(self.longitudRest!)
                
                self.restauranteLocalizacion.latitude = self.latitudRest!
                self.restauranteLocalizacion.longitude = self.longitudRest!
                
                let regionRestaurante = MKCoordinateRegion(center: self.restauranteLocalizacion, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
                
                self.mapaRestaurante.setRegion(regionRestaurante, animated: true)
                
                //Agregar el pin del restaurante
                self.pinRestaurante.coordinate = self.restauranteLocalizacion
                self.pinRestaurante.title = self.restauranteSeleccionado!
                self.mapaRestaurante.addAnnotation(self.pinRestaurante)
                //---------------------------
                
            }
            
        }
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if (view.annotation?.title)! != nil {
            
            let alertView = UIAlertController(title: "¿Cómo llegar al Restaurante?", message: "¿Quieres ver cómo llegar a tu restaurante?", preferredStyle: .actionSheet)
            
            let irMapas = UIAlertAction(title: "Ir a Mapas", style: .default) { (action) in
                
                let regionDistance:CLLocationDistance = 1000
                
                let regionSpan = MKCoordinateRegionMakeWithDistance(self.restauranteLocalizacion, regionDistance, regionDistance)
                
                let option = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
                
                if #available(iOS 10.0, *) {
                    let placemark = MKPlacemark(coordinate: self.restauranteLocalizacion)
                    let mapItem = MKMapItem(placemark: placemark)
                    mapItem.name = self.restauranteSeleccionado
                    mapItem.openInMaps(launchOptions: option)
                } else {
                    // Fallback on earlier versions
                }
                
                
                
            }
            
            let cancelar = UIAlertAction(title: "Cancelar", style: .cancel) { (action) in
                alertView.dismiss(animated: true, completion: nil)
            }
            
            alertView.addAction(irMapas)
            alertView.addAction(cancelar)
            
            present(alertView, animated: true, completion: nil)
            
        }else{
            
            print("Presionando User's location")
            
        }
        
        
        
    }
    
    
    //MARK: - Config. botones para poner la loc. exacta del restaurante o usuario
    
    @IBAction func btnLocalizacionUser(_ sender: Any) {
        
        let regionUser = MKCoordinateRegion(center: self.userLocation, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.mapaRestaurante.setRegion(regionUser, animated: true)
        
    }
    
    
    @IBAction func btnLocalizarRestaurante(_ sender: Any) {
        
        //Agarrar coodenadas del restaurante, y si son varias franquicias, pues poner un actionsheet para dar a elegir
        
        let regionRestaurante = MKCoordinateRegion(center: restauranteLocalizacion, span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04))
        
        self.mapaRestaurante.setRegion(regionRestaurante, animated: true)
        
    }
    
    
    //-----------------------------------------------------------------------------------------------------
    

}





























