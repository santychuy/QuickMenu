//
//  SeccionTVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 30/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class SeccionTVCell: UITableViewCell {

    @IBOutlet weak var labelNombreSeccion: UILabel!
    @IBOutlet weak var imageSeccion: UIImageView!
    
    func setSeccion(seccion: cellDatos) {
        
        imageSeccion.layer.borderColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        imageSeccion.layer.borderWidth = 2
        
        labelNombreSeccion.text = seccion.textoSeccion
        imageSeccion.image = seccion.imagenSeccion
        
    }
    
}
