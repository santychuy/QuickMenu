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
    
    /*private var _arrayCellData:[cellDatos]!
    private var _imageGuardar:UIImage!
    private var _seccion:String!
    private var _datosDeSeccion:cellDatos!
    

    var arrayCellData: [cellDatos] {
        get{
            return _arrayCellData
        } set{
            _arrayCellData = newValue
        }
    }

    
    var imageGuardar: UIImage {
        get{
            return _imageGuardar
        } set{
            _imageGuardar = newValue
        }
    }
    
    
    var seccion: String {
        get{
            return _seccion
        } set{
            _seccion = newValue
        }
    }
    
    
    var datosDeSeccion: cellDatos {
        get{
            return _datosDeSeccion
        } set{
            _datosDeSeccion = newValue
        }
    }*/
    
}

class cellDatos{
    
    var textoSeccion:String?
    var imagenSeccion:UIImage?
    
    /*private var _textoSeccion:String!
    private var _imagenSeccion:UIImage!
    
    var textoSeccion: String {
        get{
            return _textoSeccion
        } set{
            _textoSeccion = newValue
        }
    }
    
    var imagenSeccion: UIImage {
        get{
            return _imagenSeccion
        } set{
            _imagenSeccion = newValue
        }
    }*/
    
    
    
    init(textoSeccion:String, imagenSeccion: UIImage) {
        self.textoSeccion = textoSeccion
        self.imagenSeccion = imagenSeccion
    }
    
    
}
