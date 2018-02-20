//
//  ViewController.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 21/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    @IBOutlet weak var imageLogoCompleto: UIImageView!
    @IBOutlet weak var labelSlogan: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Se configura el video que estará en el fondo de la pantalla de bienvenida
        
        UIApplication.shared.statusBarStyle = .lightContent
        
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
    

    
    override func viewDidAppear(_ animated: Bool) {
        
        aparecerComponentes()
        
    }
    
    
    func aparecerComponentes() {
        
        UIView.animate(withDuration: 1) {
            self.imageLogoCompleto.alpha = 1
            self.aparecerLabel()
        }
        
    }
    
    func aparecerLabel() {
        
        UIView.animate(withDuration: 1) {
            self.labelSlogan.alpha = 1
        }
        
    }


}

