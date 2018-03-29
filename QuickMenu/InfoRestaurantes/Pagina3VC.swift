//
//  Pagina3VC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 16/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import SVProgressHUD
import MessageUI

class Pagina3VC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var labelMasInfo: UILabel!
    @IBOutlet weak var labelRedes: UILabel!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnInsta: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        animarElementos()
        
    }

    
    @IBAction func btnEmailAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["quickmenutechson@gmail.com"])
        //Se puede agregar más campos que podemos agregar al correo
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mail, animated: true, completion: nil)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Por el momento no se puede mandar correos, intente más tarde")
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    //Por si se rechaza enviar el correo, se devuelve a la vista anterior
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnInstaAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.instagram.com/quick.menu/")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnFBAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.facebook.com/QuickMenuApp/")
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            // Fallback on earlier versions
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    
    func animarElementos(){
        
        labelMasInfo.alpha = 0
        labelRedes.alpha = 0
        btnFB.alpha = 0
        btnEmail.alpha = 0
        btnInsta.alpha = 0
        
        
        UIView.animate(withDuration: 1, delay: 3, options: .transitionCurlUp, animations: {
            self.labelMasInfo.alpha = 1
            self.btnEmail.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 2, options: .transitionCurlUp, animations: {
            self.labelRedes.alpha = 1
            self.btnInsta.alpha = 1
            self.btnFB.alpha = 1
        }, completion: nil)
        
        
    }
    
    
    
    

}






























