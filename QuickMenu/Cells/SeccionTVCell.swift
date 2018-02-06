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
        
        labelNombreSeccion.text = seccion.textoSeccion
        imageSeccion.image = seccion.imagenSeccion
        
    }
    
}
