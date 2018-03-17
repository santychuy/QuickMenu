//
//  DatosSeccion.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 01/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import Foundation
import UIKit



class DatosSeccion {
    
    
    var arrayCellData = [cellDatos]()
    var datosDeSeccion:cellDatos?
    
    
    
}

class cellDatos{
    
    var textoSeccion:String?
    var imagenSeccion:UIImage?
    
    
    init(textoSeccion:String, imagenSeccion: UIImage) {
        self.textoSeccion = textoSeccion
        self.imagenSeccion = imagenSeccion
    }
    
    
}


class cellDatosMenu{
    
    var imagenFondo:UIImage?
    var textoRest:String?
    var imagenLogo:UIImage?
    //var textoCategoria:String?
    
    init(imagenFondo:UIImage, textoRest:String, imagenLogo:UIImage) {
        self.imagenFondo = imagenFondo
        self.textoRest = textoRest
        self.imagenLogo = imagenLogo
        //self.textoCategoria = textoCategoria
    }
    
    
    
}


class cellCollectionDatosMenu{
    
    
    var imagenRestauranteFondo:UIImage?
    var textoRestaurante:String?
    var imagenLogo:UIImage?
    var descripcionRestaurante:String?
    
    init(imagenRestauranteFondo:UIImage, textoRestaurante:String, imagenLogo:UIImage, descripcionRestaurante:String) {
        self.imagenRestauranteFondo = imagenRestauranteFondo
        self.textoRestaurante = textoRestaurante
        self.imagenLogo = imagenLogo
        self.descripcionRestaurante = descripcionRestaurante
    }
    
    
}


class cellCategoriasDatos{
    
    var imagenCategoriaFondo:UIImage?
    var nombreCategoria:String?
    
    init(imagenCategoriaFondo:UIImage, nombreCategoria:String) {
        self.imagenCategoriaFondo = imagenCategoriaFondo
        self.nombreCategoria = nombreCategoria
    }
    
}












