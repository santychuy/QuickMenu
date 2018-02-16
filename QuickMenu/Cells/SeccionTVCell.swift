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
    @IBOutlet weak var viewSeccion: UIView!
    
    func setSeccion(seccion: cellDatos) {
        
        
        imageSeccion.layer.cornerRadius = imageSeccion.frame.height / 10
        imageSeccion.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        imageSeccion.layer.borderWidth = 3
        viewSeccion.layer.cornerRadius = viewSeccion.frame.height / 14
        viewSeccion.layer.borderColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        viewSeccion.layer.borderWidth = 4
        
        labelNombreSeccion.text = seccion.textoSeccion
        imageSeccion.image = seccion.imagenSeccion
        
    }
    
}
