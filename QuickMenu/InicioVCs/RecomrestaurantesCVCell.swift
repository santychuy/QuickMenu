//
//  RecomrestaurantesCVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 02/04/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class RecomrestaurantesCVCell: UICollectionViewCell {
    
    @IBOutlet weak var imageRestaurante: UIImageView!
    @IBOutlet weak var labelNombreRestaurante: UILabel!
    @IBOutlet weak var labelCategoria: UILabel!
    @IBOutlet weak var labelDistancia: UILabel!
    
    func setCell(dato: cellRecomResDatos){
        
        imageRestaurante.contentMode = .scaleAspectFill
        imageRestaurante.clipsToBounds = true
        
        imageRestaurante.image = dato.imagenRes
        labelNombreRestaurante.text = dato.nombreRes
        labelCategoria.text = dato.nombreCategoria
        labelDistancia.text = "\((dato.distancia)!) Km."
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 15.0
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        
        
    }
    
    
}
