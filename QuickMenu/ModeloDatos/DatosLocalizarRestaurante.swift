//
//  DatosLocalizarRestaurante.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 25/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class DatosLocalizarRestaurante {
    
    private var _coordenadas = [CLLocationCoordinate2D]()
    private var _restaurantes = [String]()
    private var _userLocation = CLLocationCoordinate2D()
    
    
    var coordenadas : [CLLocationCoordinate2D]{
        return _coordenadas
    }
    
    var restaurantes : [String] {
        return _restaurantes
    }
    
    var userLocation : CLLocationCoordinate2D {
        return _userLocation
    }
    
    /*init(coordenadas:[Double], restaurantes:[String], userLocation:CLLocationCoordinate2D) {
        
        _coordenadas = coordenadas
        _restaurantes = restaurantes
        _userLocation = userLocation
        
    }*/
}
