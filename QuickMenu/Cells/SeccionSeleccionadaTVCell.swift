//
//  SeccionSeleccionadaTVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class SeccionSeleccionadaTVCell: UITableViewCell {

    @IBOutlet weak var viewSeccionSeleccionada: UIView!
    @IBOutlet weak var labelTitulosSeccionSeleccionada: UILabel!
    @IBOutlet weak var imageSeccionSeleccionada: UIImageView!
    
    func setSeccion(seccion: cellDatos) {
        
        imageSeccionSeleccionada.layer.cornerRadius = imageSeccionSeleccionada.frame.height / 10
        imageSeccionSeleccionada.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        imageSeccionSeleccionada.layer.borderWidth = 3
        viewSeccionSeleccionada.layer.cornerRadius = viewSeccionSeleccionada.frame.height / 14
        viewSeccionSeleccionada.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        viewSeccionSeleccionada.layer.borderWidth = 4
        
        labelTitulosSeccionSeleccionada.text = seccion.textoSeccion
        imageSeccionSeleccionada.image = seccion.imagenSeccion
        
    }

}
