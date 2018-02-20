//
//  SeccionSeleccionadaTVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class SeccionSeleccionadaTVCell: UITableViewCell {

    @IBOutlet weak var labelTitulosSeccionSeleccionada: UILabel!
    @IBOutlet weak var imageSeccionSeleccionada: UIImageView!
    
    func setSeccion(seccion: cellDatos) {
        
        imageSeccionSeleccionada.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        imageSeccionSeleccionada.layer.borderWidth = 2
        
        labelTitulosSeccionSeleccionada.text = seccion.textoSeccion
        imageSeccionSeleccionada.image = seccion.imagenSeccion
        
    }

}
