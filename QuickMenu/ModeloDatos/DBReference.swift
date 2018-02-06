//
//  DBReference.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 25/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class DBReference {
    
    var DataLocalizar = DatosLocalizarRestaurante()
    
    private static let _instance = DBReference()
    
    static var Instance: DBReference {
        return _instance
    }
    
    var dbRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var restaurantesRef: DatabaseReference {
        return dbRef.child("restaurantes")
    }
    
  
    //Referencia a Pescadito
    
    var pescaditoRef: DatabaseReference {
        return restaurantesRef.child("Pescaditos")
    }
    
    var pescaditoCoordRef: DatabaseReference {
        return pescaditoRef.child("coords")
    }
    
    var pescaditoMenuRef: DatabaseReference {
        return pescaditoRef.child("menu")
    }
    
    
    //Referencia a Que Rollo Sushi
    
    var queRolloSushiRef: DatabaseReference {
        return restaurantesRef.child("Que Rollo Sushi")
    }
    
    var queRolloSushiCoordRef: DatabaseReference {
        return queRolloSushiRef.child("coords")
    }
    
    var queRolloSushiMenuRef: DatabaseReference {
        return queRolloSushiRef.child("menu")
    }
    
    
    func agregarRestaurantes( restaurantesArray:[String]) {
        
        
        restaurantesRef.observeSingleEvent(of: .value) { (snapshot) in
            
            var restaurantesArray = restaurantesArray
            if let dicRestaurante = snapshot.value as? [String:Any]{
                
                for (key, _) in dicRestaurante {
                    print("Restaurante: \(key)")
                    
                    restaurantesArray.append(key)
                   
                }
                
            }
            
            print("Van \(restaurantesArray.count) en la lista")
           
        }
     
    }
    
    
    
}





















