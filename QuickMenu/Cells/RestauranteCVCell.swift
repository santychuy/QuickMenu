//
//  RestauranteCVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 02/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class RestauranteCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageRestauranteFondo: UIImageView!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var labelRestaurante: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    
    func setCell(menu: cellCollectionDatosMenu){
        
        imageRestauranteFondo.contentMode = .scaleAspectFill
        imageRestauranteFondo.clipsToBounds = true
        
        imageLogo.layer.cornerRadius = imageLogo.frame.size.width/2
        imageLogo.clipsToBounds = true
        imageLogo.layer.borderWidth = 3.0
        imageLogo.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        //Declarar los componentes
        imageRestauranteFondo.image = menu.imagenRestauranteFondo
        imageLogo.image = menu.imagenLogo
        labelRestaurante.text = menu.textoRestaurante
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
    
    
}






























