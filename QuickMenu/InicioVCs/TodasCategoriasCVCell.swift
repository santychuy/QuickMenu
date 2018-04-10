//
//  TodasCategoriasCVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/04/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class TodasCategoriasCVCell: UICollectionViewCell {
    
    @IBOutlet weak var nombreCategoria: UILabel!
    @IBOutlet weak var imageCategoria: UIImageView!
    
    func setCell(categoria: cellCategoriasDatos){
        
        imageCategoria.contentMode = .scaleAspectFill
        imageCategoria.clipsToBounds = true
        
        imageCategoria.image = categoria.imagenCategoriaFondo
        nombreCategoria.text = categoria.nombreCategoria
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15.0
        layer.borderWidth = 4
        layer.borderColor = #colorLiteral(red: 0.9988920093, green: 0.6318910718, blue: 0.002369876951, alpha: 1)
        
    }
    
}
