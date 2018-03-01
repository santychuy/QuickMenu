//
//  PruebasVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 08/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import paper_onboarding


class PruebasVC: UIViewController {
    
    @IBOutlet weak var viewOnBoarding: PaperOnboarding!
    @IBOutlet weak var btnEmpezar: UIButton!
    
    
    let funciones = Funciones()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOnBoarding.dataSource = self
        viewOnBoarding.delegate = self
        
        UIApplication.shared.isStatusBarHidden = true

        // Do any additional setup after loading the view.
    
        print("HOY ES: \(funciones.tenerDiaDeLaSemana()!)")
        
        
       
        
    }

    @IBAction func btnEmpezarAction(_ sender: Any) {
        
        
        
    }
    

}


extension PruebasVC: PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        let backgroundColor = #colorLiteral(red: 0.9215744138, green: 0.5188732743, blue: 0.1816014051, alpha: 1)
        let titleFont = UIFont(name: "Avenir-Heavy", size: 27)
        let titleFont1 = UIFont(name: "Avenir-Heavy", size: 20)
        let titleFont2 = UIFont(name: "Avenir-Heavy", size: 20)
        let descrpFont = UIFont(name: "Avenir-Roman", size: 17)
        
        return [OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "¡Bienvenido a QuickMenu!",
                                   description: "Podrás ver los platillos detalladamente de tus restaurantes favoritos",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "Ver información de tu restaurante",
                                   description: "Consulta tu restaurante para ir a visitarlos",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont1!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "Disfruta de sus excelentes platillos",
                                   description: "Ver detalladamente cada platillo que te ofrece el restaurante, ve y busca tu preferido",
                                   pageIcon: UIImage(),
                                   color: backgroundColor,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont2!,
                                   descriptionFont: descrpFont!)][index]
        
    }
    
    func onboardingConfigurationItem(item: OnboardingContentViewItem, index: Int) {
        
        
        
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            
            UIView.animate(withDuration: 1, animations: {
                self.btnEmpezar.alpha = 1
            })
            
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            
            if self.btnEmpezar.alpha == 1 {
                
                UIView.animate(withDuration: 1, animations: {
                    self.btnEmpezar.alpha = 0
                })
                
            }
            
        }
    }
    
    
}
























