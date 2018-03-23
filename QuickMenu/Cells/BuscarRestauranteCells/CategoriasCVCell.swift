//
//  CategoriasCVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 14/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class CategoriasCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCategoria: UIImageView!
    @IBOutlet weak var labelCategoria: UILabel!
    
    
    func setCell(categoria: cellCategoriasDatos){
        
        imageCategoria.contentMode = .scaleAspectFill
        imageCategoria.clipsToBounds = true
        
        imageCategoria.image = categoria.imagenCategoriaFondo
        labelCategoria.text = categoria.nombreCategoria
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15.0
        layer.borderWidth = 4
        layer.borderColor = #colorLiteral(red: 0.9988920093, green: 0.6318910718, blue: 0.002369876951, alpha: 1)
        
        

    }
    
    
}
