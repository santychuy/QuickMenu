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
    
    @IBOutlet weak var labelRestauranteDetalles: UILabel!
    @IBOutlet weak var imageLogoDetalles: UIImageView!
    @IBOutlet weak var labelDetalles: UILabel!
    @IBOutlet weak var scrollViewImagenesDetalles: UIScrollView!
    
    var pasar = false
    
    
    func setCell(menu: cellCollectionDatosMenu){
        
        imageRestauranteFondo.contentMode = .scaleAspectFill
        imageRestauranteFondo.clipsToBounds = true
        
        imageLogo.layer.cornerRadius = imageLogo.frame.size.width/2
        imageLogo.clipsToBounds = true
        imageLogo.layer.borderWidth = 1.5
        imageLogo.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        imageLogoDetalles.layer.cornerRadius = imageLogoDetalles.frame.size.width/2
        imageLogoDetalles.clipsToBounds = true
        imageLogoDetalles.layer.borderWidth = 1.5
        imageLogoDetalles.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        //Declarar los componentes
        imageRestauranteFondo.image = menu.imagenRestauranteFondo
        imageLogo.image = menu.imagenLogo
        labelRestaurante.text = menu.textoRestaurante
        
        //Declarar componentes de detalles
        labelRestauranteDetalles.text = menu.textoRestaurante
        imageLogoDetalles.image = menu.imagenLogo
        labelDetalles.text = menu.descripcionRestaurante
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
    
    @IBAction func btnDetalles(_ sender: UIButton) {
        
        if pasar == false {
            
            UIView.animate(withDuration: 0.3) {
                self.imageLogo.alpha = 0
                self.labelRestaurante.alpha = 0
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.imageLogoDetalles.alpha = 1
                self.labelDetalles.alpha = 1
                self.labelRestauranteDetalles.alpha = 1
                self.scrollViewImagenesDetalles.alpha = 1
            }, completion: { (completed) in
                self.pasar = true
            })
            
        }else {
            
            UIView.animate(withDuration: 0.3) {
                self.imageLogoDetalles.alpha = 0
                self.labelDetalles.alpha = 0
                self.labelRestauranteDetalles.alpha = 0
                self.scrollViewImagenesDetalles.alpha = 0
            }
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                self.imageLogo.alpha = 1
                self.labelRestaurante.alpha = 1
            }, completion: { (completed) in
                self.pasar = false
            })
            
        }
        
        
        
    }
    
    
    
    
}






























