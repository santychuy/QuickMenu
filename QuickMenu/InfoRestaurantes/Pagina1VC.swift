//
//  Pagina1VC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 16/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class Pagina1VC: UIViewController {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelQuickMenu: UILabel!
    @IBOutlet weak var labelSlogan: UILabel!
    @IBOutlet weak var imageFondo: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        animarElementos()
    }

    
    
    func animarElementos(){
        
        imageLogo.alpha = 0
        labelQuickMenu.alpha = 0
        labelSlogan.alpha = 0
        imageFondo.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
            self.imageFondo.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1, options: .transitionCurlUp, animations: {
            self.imageLogo.alpha = 1
            self.labelQuickMenu.alpha = 1
            self.labelSlogan.alpha = 1
        }, completion: nil)
        
        
    }
    
    
    

   

}
