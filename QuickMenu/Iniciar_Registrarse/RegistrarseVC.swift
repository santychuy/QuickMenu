//
//  RegistrarseVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 10/06/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseAuth
import SVProgressHUD
import FacebookCore
import FacebookLogin
import FBSDKLoginKit

class RegistrarseVC: UIViewController {

    @IBOutlet weak var usuarioTF: HoshiTextField!
    @IBOutlet weak var contraTF: HoshiTextField!
    @IBOutlet weak var contra2TF: HoshiTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnRegistrarte(_ sender: Any) {
        if usuarioTF.text != "" && contraTF.text != "" && contra2TF.text != "" {
            if contraTF.text == contra2TF.text {
                Auth.auth().createUser(withEmail: usuarioTF.text!, password: contraTF.text!) { (user, error) in
                    if user != nil{
                        print("Ya se creó el usuario")
                        //self.performSegue(withIdentifier: "segueRegistrarseVC-RegistrarCelularVC", sender: nil)
                    }else{
                        if let myError = error?.localizedDescription{
                            print("Error al crear usuario: ",myError)
                            self.usuarioTF.text = ""
                            self.contraTF.text = ""
                            self.contra2TF.text = ""
                            SVProgressHUD.showError(withStatus: "Error al crear la cuenta intente más tarde")
                        }
                    }
                }
            }else{
                print("No coinciden las contraseñas")
                usuarioTF.text = ""
                contraTF.text = ""
                contra2TF.text = ""
                SVProgressHUD.showError(withStatus: "No coinciden las contraseñas, volver a escribirlas")
            }
        }else{
            print("Llenar información de todos los campos")
            usuarioTF.text = ""
            contraTF.text = ""
            contra2TF.text = ""
            SVProgressHUD.showError(withStatus: "Llenar todos los campos requeridos")
        }
    }
    
    
    @IBAction func btnFB(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Se inició sesion con Facebook")
                //Verificar si ya tiene cuenta registrada con datos
                self.signInFirebase()
            case .failed(let error):
                print("Hubo un error: ", error.localizedDescription)
            case .cancelled:
                print("Cancelado")
            }
        }
    }
    
    
    fileprivate func signInFirebase(){
        guard let authToken = AccessToken.current?.authenticationToken else {return}
        let credential = FacebookAuthProvider.credential(withAccessToken: authToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if error != nil{
                print("Hubo un error al autenticar con Firebase: ",error?.localizedDescription as Any)
                return
            }
            print("Se inició sesión en Firebase")
            //self.performSegue(withIdentifier: "segueRegistrarseVC-RegistrarCelularVC", sender: nil)
        }
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email, picture.type(large)"]).start { (connection, result, error) in
            
            if error != nil{
                print("ERROR AL OBTENER INFO DEL USUARIO FB: \(error?.localizedDescription ?? "")")
                return
            }
            
            print(result ?? "")
            
        }
    }

}






















