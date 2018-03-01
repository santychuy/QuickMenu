//
//  MenusTVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 25/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class MenusTVCell: UITableViewCell {

    
    @IBOutlet weak var imageFondoRestaurante: UIImageView!
    @IBOutlet weak var imageLogoRestaurante: UIImageView!
    @IBOutlet weak var labelCategoria: UILabel!
    @IBOutlet weak var labelRestaurante: UILabel!
    
    
    func setCell(menu: cellDatosMenu){
        
        
        
        imageFondoRestaurante.contentMode = .scaleAspectFill
        imageFondoRestaurante.clipsToBounds = true
        
        imageFondoRestaurante.image = menu.imagenFondo
        imageLogoRestaurante.image = menu.imagenLogo
        labelRestaurante.text = menu.textoRest
        
    }

    
}
