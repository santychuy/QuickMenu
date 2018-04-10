//
//  PruebaCVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 30/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class PruebaCVCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelPrueba: UILabel!
    @IBOutlet weak var imageFondoCategoria: UIImageView!
    
    func setCell(categoria: cellCategoriasDatos){
        
        imageFondoCategoria.contentMode = .scaleAspectFill
        imageFondoCategoria.clipsToBounds = true
        
        imageFondoCategoria.image = categoria.imagenCategoriaFondo
        labelPrueba.text = categoria.nombreCategoria
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15.0
        layer.borderWidth = 4
        layer.borderColor = #colorLiteral(red: 0.9988920093, green: 0.6318910718, blue: 0.002369876951, alpha: 1)
        
    }
    
}
