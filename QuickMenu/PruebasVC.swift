//
//  PruebasVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 08/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit


class PruebasVC: UIViewController {
    
    
 
    @IBOutlet weak var viewPruebas: UIView!
    
    let funciones = Funciones()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
        print("HOY ES: \(funciones.tenerDiaDeLaSemana()!)")
       
        
    }

    
    
    

  

}
