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
        
        imageSeccionSeleccionada.layer.cornerRadius = imageSeccionSeleccionada.frame.height / 11
        imageSeccionSeleccionada.layer.borderColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        imageSeccionSeleccionada.layer.borderWidth = 3
        
        labelTitulosSeccionSeleccionada.text = seccion.textoSeccion
        imageSeccionSeleccionada.image = seccion.imagenSeccion
        
    }

}
