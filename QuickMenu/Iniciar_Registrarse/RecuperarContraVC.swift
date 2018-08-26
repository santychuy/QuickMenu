//
//  RecuperarContraVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 16/08/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import SVProgressHUD

class RecuperarContraVC: UIViewController {

    @IBOutlet weak var correoTF: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRecuperar(_ sender: Any) {
        
        SVProgressHUD.show()
        if correoTF.text != "" {
            
            Auth.auth().sendPasswordReset(withEmail: correoTF.text!) { (error) in
                if error != nil {
                    print("Error: ",error?.localizedDescription as Any)
                    SVProgressHUD.showError(withStatus: "hubo un error al mandar el correo, intentar más tarde")
                }else{
                    print("Correo enviado")
                    SVProgressHUD.showSuccess(withStatus: "¡Correo de restablecimiento de contraseña enviado!")
                    self.performSegue(withIdentifier: "unwindSegueRestablecer-EntrarVC", sender: self)
                }
            }
            
        }else{
            SVProgressHUD.showError(withStatus: "Poner e-mail para poder continuar")
        }
        
    }
    
    

}
















