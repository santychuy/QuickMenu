//
//  CreditosTVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 12/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import SVProgressHUD
import MessageUI

class CreditosTVC: UITableViewController, MFMailComposeViewControllerDelegate {


    @IBOutlet weak var viewSanty: UIView!
    @IBOutlet weak var btnFBSanty: UIButton!
    @IBOutlet weak var btnTwitterSanty: UIButton!
    @IBOutlet weak var btnInstagramSanty: UIButton!
    @IBOutlet weak var btnEmailSanty: UIButton!
    
    

    @IBOutlet weak var viewFergie: UIImageView!
    @IBOutlet weak var btnFBFergie: UIButton!
    @IBOutlet weak var btnTwitterFergie: UIButton!
    @IBOutlet weak var btnInstagramFergie: UIButton!
    @IBOutlet weak var btnEmailFergie: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewSanty.alpha = 0
        viewFergie.alpha = 0
        
        configNavBar()
        configAnimaciones()
        
        
        
    }
    
    
    //MARK: - Funciones botones redes sociales SANTY
    
    @IBAction func btnFBSantyAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.facebook.com/santiago.carrasco.7")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
       
    }
    
    @IBAction func btnTwitterSantyAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://twitter.com/santychuy")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnInstagramSantyAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.instagram.com/santychuy/")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnEmailSantyAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["techson17@gmail.com"])
        //Se puede agregar más campos que podemos agregar al correo
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mail, animated: true, completion: nil)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Por el momento no se puede mandar correos, intente más tarde")
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    //Por si se rechaza enviar el correo, se devuelve a la vista anterior
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    //----------------------------------------------------------------------------------
    
    
    
    //MARK: - Funciones botones redes sociales FERGIE
    
    
    @IBAction func btnFBFergieAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.facebook.com/fergieee.ru")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnTwitterFergieAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://twitter.com/ferrodriguezu28")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnInstagramFergieAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.instagram.com/fergie.ruphotography/")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnEmailFergieAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setToRecipients(["mfer_ru28@hotmail.com"])
        //Se puede agregar más campos que podemos agregar al correo
        
        if MFMailComposeViewController.canSendMail()
        {
            self.present(mail, animated: true, completion: nil)
        }
        else
        {
            SVProgressHUD.showError(withStatus: "Por el momento no se puede mandar correos, intente más tarde")
        }
        
        SVProgressHUD.dismiss()
        
    }
    
    
    //------------------------------------------------------------------------------------------
    
    
    //MARK: - Config. Barra Navegacion
    
    
    func configNavBar() {
        
        navigationItem.title = "Créditos"
        
    }
    
    
    //------------------------------------------------------------------
    
    
    //MARK: - Config. animaciones
    
    func configAnimaciones() {
        
        UIView.animate(withDuration: 2, delay: 0, options: .transitionCurlDown, animations: {
            self.viewSanty.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 1, options: .transitionCurlDown, animations: {
            self.viewFergie.alpha = 1
        }, completion: nil)
        
    }
    
    //-------------------------------------------------------------------------------------------
    
    
}





























