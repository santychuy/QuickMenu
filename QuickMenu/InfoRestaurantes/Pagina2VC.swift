//
//  Pagina2VC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 16/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class Pagina2VC: UIViewController {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelQuickMenu: UILabel!
    @IBOutlet weak var labelMensaje: UILabel!
    @IBOutlet weak var scrollViewImagenesLogos: UIScrollView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        animarElementos()
    }

    
    func animarElementos(){
        
        labelQuickMenu.alpha = 0
        labelMensaje.alpha = 0
        scrollViewImagenesLogos.alpha = 0
        
        
        UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: {
            self.labelQuickMenu.alpha = 1
            self.labelMensaje.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1, options: .transitionCurlUp, animations: {
            self.scrollViewImagenesLogos.alpha = 1
        }, completion: nil)
        
        
    }
    
    
    


}
