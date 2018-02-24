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
import Auk


private let headerHeight:CGFloat = 265
private let headerCut: CGFloat = 50


class PlatilloSeleccionadoTVC: UITableViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var labelNombrePlatillo: UILabel!
    @IBOutlet weak var labelDescripcionPlatillo: UILabel!
    @IBOutlet weak var labelPrecio: UILabel!
    @IBOutlet weak var imageLogoEmpty1: UIImageView!
    @IBOutlet weak var imageLogoEmpty2: UIImageView!
    
    var platilloSeleccionado:String?
    var restauranteSeleccionado:String?
    var seccionSeleccionada:String?
    
    
    

    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configNavBar()
        descargarImagenesADesplegar()
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
        

        
        
    }
    
    
    func descargarImagenesADesplegar(){
        
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.startAutoScroll(delaySeconds: 3.0)
        
        
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
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        
        let referenceImage1 = Storage.storage().reference().child("\(restauranteSeleccionado!)/menu/\(seccionSeleccionada!)/\(platilloSeleccionado!)/1.jpg")
        
        referenceImage1.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return ()
                
            } else { //Hubo exito
                
                let imagen = UIImage(data: data!)
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        
        let referenceImage2 = Storage.storage().reference().child("\(restauranteSeleccionado!)/menu/\(seccionSeleccionada!)/\(platilloSeleccionado!)/2.jpg")
        
        referenceImage2.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return ()
                
            } else { //Hubo exito
                
                let imagen = UIImage(data: data!)
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        
        
    }
    

    func configNavBar() {
        
        navigationItem.title = platilloSeleccionado
        
        let compartirBtn:UIButton = UIButton.init(type: .custom)
        compartirBtn.setImage(#imageLiteral(resourceName: "Share"), for: .normal)
        compartirBtn.addTarget(self, action: #selector(compartirFunc), for: .touchUpInside)
        compartirBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let compartirBtnBar = UIBarButtonItem(customView: compartirBtn)
        
        self.navigationItem.setRightBarButton(compartirBtnBar, animated: false)
    }
    
    @objc func compartirFunc(){
        
        let indexFotoActual = scrollView.auk.currentPageIndex
        let imageFotoActual = scrollView.auk.images[indexFotoActual!]
        
        let activityItems:[Any] = [imageFotoActual,
                                   labelNombrePlatillo.text!,
                                   labelDescripcionPlatillo.text!]
        
        let avc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        self.present(avc, animated: true, completion: nil)
        
    }
    
    
  
    func configImageSettings() {
        
        UIView.animate(withDuration: 1.5, delay: 0, options: .transitionCrossDissolve, animations: {
            self.scrollView.alpha = 1
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 1, options: .curveLinear, animations: {
            self.imageLogoEmpty1.alpha = 0.4
            self.imageLogoEmpty2.alpha = 0.4
        }, completion: nil)
        
    }
    
    
    
    
    
    
    //MARK: - Config. tocar imagen para hacer zoom
    
    
    
    func configImageZoom(){
        
        
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoomImage)))
        
    }
    
    var startingFrame: CGRect?
    var blackBg: UIView?
    var scrollViewZoom: UIScrollView = UIScrollView()
    var zoomingImageView: UIImageView?
    var newFrame:CGRect?
    
    @objc func animateZoomImage(){
        
        print("Se a presionado la imagen")
        
        self.scrollView.alpha = 0
        
        let indexImage = scrollView.auk.currentPageIndex
        print(indexImage!)
        let imageMostrar = scrollView.auk.images[indexImage!]
        print(imageMostrar)
        //let imageViewMostrar = UIImageView(image: imageMostrar)
        
        //Sacar las medidas que tiene el scrollView de las imagenes
        startingFrame = scrollView.superview?.convert(scrollView.frame, to: nil)
        print(startingFrame!)
        
        
        
        //La vista que hará que tendrá la foto
        zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView?.backgroundColor = UIColor.red
        zoomingImageView?.image = imageMostrar
        zoomingImageView?.contentMode = .scaleAspectFill
        zoomingImageView?.clipsToBounds = true
        zoomingImageView?.isUserInteractionEnabled = true
        zoomingImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateZoomImageOut)))
        zoomingImageView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoomImagePinch)))
        //zoomingImageView?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(moverImagen)))
        
        
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            //Crear el fondo negro que tendrá a la hora de picarle para el zoom
            blackBg = UIView(frame: keyWindow.frame)
            blackBg?.backgroundColor = UIColor.black
            blackBg?.alpha = 0
            keyWindow.addSubview(blackBg!)
            keyWindow.addSubview(zoomingImageView!)
            
            //Hará la animacion que hará el "zoom" y le daremos las nuevas medidas que tomará para el zoom
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBg?.alpha = 0.9
                
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                self.zoomingImageView?.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                self.newFrame = self.zoomingImageView?.frame
                
                
                self.zoomingImageView?.center = keyWindow.center
                
            
            })
            
            
            
        }
        
        
    }
    
    
    @objc func animateZoomImageOut(tapGesture: UITapGestureRecognizer){
        
        if let zoomOutImageView = tapGesture.view{
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                
                self.blackBg?.alpha = 0
                
            }, completion: { (completed) in
                zoomOutImageView.removeFromSuperview()
                self.scrollView.alpha = 1
            })
            
            
            
        }
        
        
    }
    
    
    func configScrollViewZoom(){
        
        scrollViewZoom.delegate = self
        scrollViewZoom.minimumZoomScale = 1.0
        scrollViewZoom.maximumZoomScale = 6.0
        //scrollViewZoom?.frame = startingFrame!
        scrollViewZoom.alwaysBounceVertical = false
        scrollViewZoom.alwaysBounceHorizontal = false
        scrollViewZoom.showsHorizontalScrollIndicator = false
        scrollViewZoom.showsVerticalScrollIndicator = false
        scrollViewZoom.flashScrollIndicators()
        
        
    }
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("Se quiere hacer zoom")
        return zoomingImageView
    }
    
    @objc func zoomImagePinch(sender: UIPinchGestureRecognizer) {
        
        sender.delegate = self
        
        print("Haciendo zoommmmmm")
        
        if sender.state == .began || sender.state == .changed {
            
            /*let currentScale = CGFloat((self.zoomingImageView?.frame.size.width)!) / CGFloat((self.zoomingImageView?.bounds.size.width)!)
            var newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
            }
            if newScale > 6 {
                newScale = 6
            }
            
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            
            self.zoomingImageView?.transform = transform
            sender.scale = 1*/
            
            guard let view = sender.view else {return}
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX,
                                      y: sender.location(in: view).y - view.bounds.midY)
            
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
            
            let currentScale = CGFloat((self.zoomingImageView?.frame.size.width)!) / CGFloat((self.zoomingImageView?.bounds.size.width)!)
            var newScale = currentScale*sender.scale
            
            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.zoomingImageView?.transform = transform
                sender.scale = 1
            }else {
                view.transform = transform
                sender.scale = 1
            }
            
        }
        
        if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.zoomingImageView?.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                
            })
            
        }
        
        
        
        
        
    }
    
    @objc func moverImagen(sender: UIPanGestureRecognizer){
        
        sender.delegate = self
        
        print("Se está moviendo la imagen")
        
        var initialCenter = CGPoint()
        
        if sender.state == .began {
            
            initialCenter = (zoomingImageView?.center)!
            print(initialCenter)
            
        }
        
        if sender.state == .changed {
            
            let translation = sender.translation(in: self.zoomingImageView)
            let changex = (zoomingImageView?.center.x)! + translation.x
            let changey = (zoomingImageView?.center.y)! + translation.y
            
            sender.view?.center = CGPoint(x: changex, y: changey)
            sender.setTranslation(CGPoint.zero, in: sender.view)
            
        }
        
        if sender.state == .ended {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.zoomingImageView?.center = initialCenter
            })
            
        }
        
        
        
    }
    
    
    
    
    //-----------------------------------------------------------------------------------
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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























