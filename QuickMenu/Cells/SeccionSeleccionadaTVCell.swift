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
        
        labelTitulosSeccionSeleccionada.text = seccion.textoSeccion
        imageSeccionSeleccionada.image = seccion.imagenSeccion
        
    }

}
