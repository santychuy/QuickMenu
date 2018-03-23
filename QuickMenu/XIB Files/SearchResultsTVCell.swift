//
//  SearchResultsTVCell.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 22/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class SearchResultsTVCell: UITableViewCell {

    @IBOutlet weak var labelRestaurante: UILabel!
    @IBOutlet weak var labelCategoria: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
