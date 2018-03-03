//
//  PruebasVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 08/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import paper_onboarding
import AVFoundation


class TutorialVC: UIViewController {
    
    @IBOutlet weak var viewOnBoarding: PaperOnboarding!
    @IBOutlet weak var btnEmpezar: UIButton!
    
    
    let funciones = Funciones()
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewOnBoarding.dataSource = self
        viewOnBoarding.delegate = self
        
        configVideoFondo()
        
        UIApplication.shared.isStatusBarHidden = true

        // Do any additional setup after loading the view.
    
        print("HOY ES: \(funciones.tenerDiaDeLaSemana()!)")
        
        
       
        
    }

    @IBAction func btnEmpezarAction(_ sender: Any) {
        
        /*let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "onBoardingComplete")
        userDefaults.synchronize()*/
        
    }
    
    func configVideoFondo(){
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: [.mixWithOthers])
            try audioSession.setActive(true)
        }catch{
            print(error.localizedDescription)
        }
        
        let videoURL = Bundle.main.url(forResource: "VideoIntro", withExtension: "mp4")
        
        player = AVPlayer.init(url: videoURL!)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.frame = view.layer.frame
        
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        player.play()
        
        view.layer.insertSublayer(playerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notitication:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
    }
    
    //MARK: - Función para cuando lleve a 0 el video se ejecute la acción de volver a repetir en la parte de arriba
    @objc func playerItemReachEnd(notitication:NSNotification){
        
        player.seek(to: kCMTimeZero)
        
    }
    

}


extension TutorialVC: PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem(at index: Int) -> OnboardingItemInfo {
        
        //let backgroundColor = #colorLiteral(red: 0.9215744138, green: 0.5188732743, blue: 0.1816014051, alpha: 1)
        let backGroundTransparent = UIColor(white: 0, alpha: 0)
        let titleFont = UIFont(name: "AvenirNext-DemiBold", size: 29)
        let descrpFont = UIFont(name: "Avenir-Roman", size: 19)
        
        return [OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "¡Bienvenido a QuickMenu!",
                                   description: "Podrás ver los platillos detalladamente de tus restaurantes favoritos en tus manos",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "Restaurantes actualizado",
                                   description: "Consulta tu restaurante para saber más de ellos e ir a visitarlos",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!),
                
                OnboardingItemInfo(informationImage: #imageLiteral(resourceName: "LogoLaunch"),
                                   title: "Platillos detallados",
                                   description: "Ver detalladamente cada platillo que te ofrece el restaurante, ve y busca tu preferido",
                                   pageIcon: UIImage(),
                                   color: backGroundTransparent,
                                   titleColor: UIColor.white,
                                   descriptionColor: UIColor.white,
                                   titleFont: titleFont!,
                                   descriptionFont: descrpFont!)][index]
        
    }
    
    
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            
            UIView.animate(withDuration: 0.5, animations: {
                self.btnEmpezar.alpha = 1
            })
            
        }
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            
            if self.btnEmpezar.alpha == 1 {
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.btnEmpezar.alpha = 0
                })
                
            }
            
        }
    }
    
    
}
























