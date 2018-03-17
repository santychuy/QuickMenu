//
//  InfoQuickMenuVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 01/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import AVFoundation
import paper_onboarding
import MessageUI
import SVProgressHUD

class InfoQuickMenuVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var viewPaperOnboarding: PaperOnboarding!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnInstagram: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setInfoBtn()
        viewPaperOnboarding.alpha = 0
        btnEmail.alpha = 0
        btnInstagram.alpha = 0
        btnFacebook.alpha = 0
        
        UIView.animate(withDuration: 1) {
            self.viewPaperOnboarding.alpha = 1
        }
        
        viewPaperOnboarding.dataSource = self
        viewPaperOnboarding.delegate = self
    }

    
    func setInfoBtn(){
        
        let infoBtn = UIButton(type: .custom)
        infoBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        infoBtn.setTitle("Creditos", for: .normal)
        infoBtn.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        infoBtn.addTarget(self, action: #selector(irACreditos), for: .touchUpInside)
        
        let infoBtnNavBar:UIBarButtonItem = UIBarButtonItem(customView: infoBtn)
        self.navigationItem.setRightBarButton(infoBtnNavBar, animated: false)
        
    }
    
    @objc func irACreditos(){
        
        /*let storyBoard = UIStoryboard(name: "Main", bundle: nil)
         let introRestauranteVC = storyBoard.instantiateViewController(withIdentifier: "CreditosVC")
         self.present(introRestauranteVC, animated: true, completion: nil)*/
        
        performSegue(withIdentifier: "segueCreditos", sender: nil)
        
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
    
    
    @IBAction func btnInstagramAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.instagram.com/quick.menu/")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnFacebookAction(_ sender: Any) {
        
        SVProgressHUD.show()
        
        let url = URL(string:"https://www.facebook.com/QuickMenuApp/")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    

    
}


extension InfoQuickMenuVC: PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        //let backgroundColor = #colorLiteral(red: 0.9215744138, green: 0.5188732743, blue: 0.1816014051, alpha: 1)
        let backGroundTransparent = UIColor(white: 0, alpha: 0)
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 37)
        let titleFontInfo = UIFont(name: "AvenirNext-DemiBold", size: 30)
        let descrpFont = UIFont(name: "Avenir-Roman", size: 21)
        
        return [OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "QuickMenu",
                                   description: "Menú de tu restaurante favorito en tus manos",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "QuickMenu",
                                   description: "Da a conocer a tu restaurante y tus platillos a nuestros usuarios",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "",
                                   description: "",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFontInfo!,
                                   descriptionFont: descrpFont!)][index]
        
    }
    
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        
        if index == 2 {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.btnEmail.alpha = 1
                self.btnInstagram.alpha = 1
                self.btnFacebook.alpha = 1
            })
            
        }
        
    }
    
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        
        if index == 1 {
            
            if self.btnEmail.alpha == 1 {
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.btnEmail.alpha = 0
                    self.btnInstagram.alpha = 0
                    self.btnFacebook.alpha = 0
                })
                
            }
            
        }
        
    }
    
    
}








































