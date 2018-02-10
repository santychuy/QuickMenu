//
//  PlatilloSeleccionadoVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


private let headerHeight:CGFloat = 265
private let headerCut: CGFloat = 50


class PlatilloSeleccionadoTVC: UITableViewController {

    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var imageViewPlatillos: UIImageView!
    @IBOutlet weak var labelNombrePlatillo: UILabel!
    @IBOutlet weak var labelDescripcionPlatillo: UILabel!
    @IBOutlet weak var labelPrecio: UILabel!
    
    var platilloSeleccionado:String?
    var restauranteSeleccionado:String?
    var seccionSeleccionada:String?
    
    var zoomImageView = UIImageView()
    //let startingFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configNavBar()
        queryDetallesPlatillo()
        configImageSettings()
        configImageZoom()
    }

 
    func queryDetallesPlatillo() {
    
        
    Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("menu").child(seccionSeleccionada!).child(platilloSeleccionado!).observeSingleEvent(of: .value) { (snapshot) in
        
        
            print(snapshot)
        
            if let dicPlatillo = snapshot.value as? [String:Any] {
            
                self.labelNombrePlatillo.text = dicPlatillo["nombre"] as? String
                self.labelDescripcionPlatillo.text = dicPlatillo["descp"] as? String
                self.labelPrecio.text = dicPlatillo["precio"] as? String
            
            }
        
        }
        

        
        let referenceImage = Storage.storage().reference().child("\(restauranteSeleccionado!)/menu/\(seccionSeleccionada!)/\(platilloSeleccionado!)/\(platilloSeleccionado!).jpg")
        
        referenceImage.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                SVProgressHUD.showError(withStatus: "No se pudieron cargar las imagenes, intentar más tarde este menú")
                //Segue para la eleccion del menu
                self.performSegue(withIdentifier: "unwindSegueBuscarRestaurante", sender: self)
                return ()
                
            } else { //Hubo exito
                
                let imagen = UIImage(data: data!)
                
                self.imageViewPlatillos.image = imagen
                
            }
            
        }
        
        
    }
    

    func configNavBar() {
        
        navigationItem.title = platilloSeleccionado
        
        let compartirBtn:UIButton = UIButton.init(type: .custom)
        compartirBtn.setImage(#imageLiteral(resourceName: "Compartit"), for: .normal)
        compartirBtn.addTarget(self, action: #selector(compartirFunc), for: .touchUpInside)
        compartirBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let compartirBtnBar = UIBarButtonItem(customView: compartirBtn)
        
        self.navigationItem.setRightBarButton(compartirBtnBar, animated: false)
    }
    
    @objc func compartirFunc(){
        
        let activityItems:[Any] = [imageViewPlatillos.image!,
                                   labelNombrePlatillo.text!,
                                   labelDescripcionPlatillo.text!]
        
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
        
    }
    
    
  
    func configImageSettings() {
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.imageViewPlatillos.alpha = 1
        }, completion: nil)
        
        
        
    }
    
    
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewPlatillos
    }
    
    
    
    func configImageZoom(){
        
        
        imageViewPlatillos.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoomImage)))
        
    }
    
    @objc func animateZoomImage(){
        
        print("Se a presionado la imagen")
        
        
        
    }
    
    
    //MARK: - Config. Imagen que se haga grande al bajar en la tabe
    
    
    
    
    
    //
    
    
    /*override func scrollViewDidScroll(_ scrollView: UIScrollView) { //Ojo
        
        let y = 265 - (scrollView.contentOffset.y - 265)
        print(y)
        let h = max(0, y)
        
        let react = CGRect(x: 0, y: 0, width: view.bounds.width, height: h)
        
        imageViewPlatillos.frame = react
        
    }*/
    
    
    
    /*func configZoom(){
        
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView = imageViewPlatillos
        
        
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PlatilloSeleccionadoTVC.animateZoom)))
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoomOut)))
        
        view.addSubview(zoomImageView)
        
        
    }
    
    
    let blackBackgroundView = UIView()
    
    @objc func animateZoom(){
        
        print("Hola tocaste en el cuadro")
        
        if let startingFrame = self.imageViewPlatillos.superview?.convert(self.imageViewPlatillos.frame, to: nil) {
            
            imageViewPlatillos.alpha = 0
            
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            self.zoomImageView.frame = startingFrame
            
            UIView.animate(withDuration: 0.75) {
                
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                
                let y = self.view.frame.height / 2 - height / 2
                
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                
                self.blackBackgroundView.alpha = 1
            }
            
        }
        
        
        
    }
    
    @objc func animateZoomOut() {
        
        if let startingFrame = self.imageViewPlatillos.superview?.convert(self.imageViewPlatillos.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: {
                
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                
            }, completion: { (didComplete) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.imageViewPlatillos.alpha = 1
            })
            
            
        }
        
    }*/
    
    

}























