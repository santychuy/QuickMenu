//
//  PruebasVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 08/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Auk

class PruebasVC: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    

    let imageArray = [#imageLiteral(resourceName: "Hamburguesa"), #imageLiteral(resourceName: "Pescadito Perisur")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        
        
        for i in 0..<imageArray.count{
            
            let image = imageArray[i]
            
            scrollView.auk.show(image: image)
            
        }
        
        scrollView.auk.startAutoScroll(delaySeconds: 5.0)
        scrollView.auk.settings.contentMode = .scaleAspectFit
        
        
    }

    
    
    

  

}
