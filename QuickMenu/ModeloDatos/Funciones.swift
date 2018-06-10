//
//  DatosSeccionSeleccinada.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import Foundation
import UIKit

class Funciones{
    
    
    func generarNumeroRandom(_ from:Int, _ to:Int, _ cantidad:Int?) -> [Int] {
        
        var numeroRandom = [Int]()
        var rangoDeNumeros = cantidad
        
        let lower = UInt32(from)
        let higher = UInt32(to+1)
        
        if rangoDeNumeros == nil || rangoDeNumeros! > (to-from) + 1{
            
            rangoDeNumeros = (to-from) + 1
            
        }
        
        while numeroRandom.count != rangoDeNumeros {
            
            let myNumber = arc4random_uniform(higher - lower) + lower
            
            if !numeroRandom.contains(Int(myNumber)) {
                
                numeroRandom.append(Int(myNumber))
                
            }
            
        }
        
        return numeroRandom
        
    }
    
    
    
    func tenerDiaDeLaSemana() -> String? {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  = "EEEE"//"EE" to get short style
        let dayInWeek = dateFormatter.string(from: date)//"Sunday"
        
        print(dayInWeek)
        
        switch dayInWeek {
        case "Monday":
            return "Lunes"
        case "Tuesday":
            return "Martes"
        case "Wednesday":
            return "Miercoles"
        case "Thursday":
            return "Jueves"
        case "Friday":
            return "Viernes"
        case "Saturday":
            return "Sabado"
        case "Sunday":
            return "Domingo"
        default:
            return nil
        }
        
        
    }
    
    
    func tenerHoraDelDia() -> String? {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        //let minutes = calendar.component(.minute, from: date)
        //let seconds = calendar.component(.second, from: date)
        
        let horaCompleta = "\(hour)"
        
        return horaCompleta
        
    }
    
    
    
    
    
}




























