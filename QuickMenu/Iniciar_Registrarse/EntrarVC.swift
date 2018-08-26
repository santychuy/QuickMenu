//
//  EntrarVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 10/06/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import FirebaseAuth
import TextFieldEffects
import SVProgressHUD
import FacebookLogin
import FacebookCore
import FBSDKLoginKit

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
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            SVProgressHUD.show()
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Se inició sesion con Facebook")
                self.signInFirebase()
            case .failed(let error):
                print("Hubo un error: ", error.localizedDescription)
                SVProgressHUD.showError(withStatus: "Hubo un error, intente más tarde")
            case .cancelled:
                print("Cancelado")
                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBAction func btnEntrar(_ sender: Any) {
        SVProgressHUD.show()
        if TFUsuario.text != "" && TFContraseña.text != "" {
            Auth.auth().signIn(withEmail: TFUsuario.text!, password: TFContraseña.text!) { (user, error) in
                if user != nil {
                    print("Ya se inició sesión con e-mail")
                    SVProgressHUD.dismiss()
                    //self.performSegue(withIdentifier: "segueEntrarVC-MainAppVC", sender: nil)
                }else{
                    if let myError = error?.localizedDescription{
                        print(myError)
                        print("Poner correo correctamente")
                        SVProgressHUD.showError(withStatus: "Hubo un error: \(myError)")
                    }else{
                        print("ERROR CABRON")
                    }
                }
            }
            
        }else{
            print("Llenar los espacios requeridos")
            TFUsuario.text = ""
            TFContraseña.text = ""
            SVProgressHUD.showError(withStatus: "Llenar todos los campos requeridos")
        }
    }
    
    fileprivate func signInFirebase(){
        guard let authToken = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil{
                print("Hubo un error al autenticar con Firebase: ",error?.localizedDescription as Any)
                SVProgressHUD.showError(withStatus: "Hubo un error, intentar más tarde")
                return
            }
            print("Se inició sesión en Firebase")
            SVProgressHUD.dismiss()
            //self.performSegue(withIdentifier: "segueEntrarVC-MainAppVC", sender: nil)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, picture.type(large)"]).start { (connection, result, error) in
            
            if error != nil{
                print("ERROR AL OBTENER INFO DEL USUARIO FB: \(error?.localizedDescription ?? "")")
                return
            }
            
            guard let userInfo = result as? [String: Any] else {return}
            
            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                print("URL IMAGE: ",imageURL)
            }
            
            print(result ?? "")
            
        }
    }
    
    
    func configNavBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    @IBAction func unwindSegueEntrarVC(_ sender: UIStoryboardSegue){}
    

}












