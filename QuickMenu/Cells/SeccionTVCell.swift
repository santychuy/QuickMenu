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
        
        imageSeccion.layer.cornerRadius = imageSeccion.frame.height / 11
        imageSeccion.layer.borderColor = #colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)
        imageSeccion.layer.borderWidth = 3
        
        labelNombreSeccion.text = seccion.textoSeccion
        imageSeccion.image = seccion.imagenSeccion
        
    }
    
}
