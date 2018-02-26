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
        
        
        imageLogoRestaurante.layer.cornerRadius = imageLogoRestaurante.frame.size.width/2
        imageLogoRestaurante.clipsToBounds = true
        imageLogoRestaurante.contentMode = .scaleAspectFill
        imageLogoRestaurante.layer.borderWidth = 1
        imageLogoRestaurante.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        imageFondoRestaurante.contentMode = .scaleAspectFill
        imageFondoRestaurante.clipsToBounds = true
        
        imageFondoRestaurante.image = menu.imagenFondo
        imageLogoRestaurante.image = menu.imagenLogo
        labelRestaurante.text = menu.textoRest
        
    }

    
}
