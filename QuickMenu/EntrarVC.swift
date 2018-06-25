//
//  EntrarVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 10/06/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import TextFieldEffects

class EntrarVC: UIViewController {

    
    @IBOutlet weak var TFUsuario: HoshiTextField!
    @IBOutlet weak var TFContraseña: HoshiTextField!
    @IBOutlet weak var BtnFB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func BtnFBAction(_ sender: UIButton) {
    }
    
    func configNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    

}












