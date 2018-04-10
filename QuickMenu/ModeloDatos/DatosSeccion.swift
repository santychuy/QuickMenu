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

class cellRecomResDatos{
    var imagenRes:UIImage?
    var nombreRes:String?
    var nombreCategoria:String?
    var distancia:String?
    
    init(imagenRes:UIImage, nombreRes:String, nombreCategoria:String, distancia:String) {
        self.imagenRes = imagenRes
        self.nombreRes = nombreRes
        self.nombreCategoria = nombreCategoria
        self.distancia = distancia
    }
}



class datosVistoRecientemente{
    
    var categoria:String?
    var restaurante:String?
    
    var arrayVistoRecientes = [datosVistoRecientemente]()
    
    init(categoria:String, restaurante:String) {
        self.categoria = categoria
        self.restaurante = restaurante
    }
    
}












