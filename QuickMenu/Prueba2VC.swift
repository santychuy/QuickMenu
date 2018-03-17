//
//  Prueba2VC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 02/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class Prueba2VC: UIViewController {

    
    var restaurantesMenu = [cellCollectionDatosMenu]()
    
    let cellScaling: CGFloat = 0.73
    
    @IBOutlet weak var collectionViewRestaurantes: UICollectionView!
    @IBOutlet weak var viewCargando: UIView!
    
    var indexPasar:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configCollection()
        
        collectionViewRestaurantes.delegate = self
        collectionViewRestaurantes.dataSource = self
        
        if restaurantesMenu.count == 0{
            
            self.viewCargando.isHidden = false
            
        }
        
        agarrarRestaurantes()
        configBtnRefrescar()
        
    }
    
    
    func configCollection(){
        
        let scrennSize = UIScreen.main.bounds.size
        let cellWidth = floor(scrennSize.width * cellScaling)
        let cellHeight = floor(scrennSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionViewRestaurantes.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionViewRestaurantes.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? LocalizarRestauranteVC {
            
            //let cell = sender as! RestauranteCVCell
            destination.textFieldRestaurante.text = restaurantesMenu[(indexPasar?.row)!].textoRestaurante
            
        }
        
        
    }

    
    
    func agarrarRestaurantes(){
        
        Database.database().reference().child("restaurantes").observe(.childAdded) { (snapshot) in
            print("Hola \(snapshot.key)")
            
            SVProgressHUD.show()
            
            print(snapshot.key)
            let restaurante = snapshot.key
            var imagenLogo:UIImage?
            var imagenFondo:UIImage?
            var descpRest:String?
            var pagado:Bool?
            
            let dic = snapshot.value as? [String:Any]
            
            descpRest = dic!["descpRestaurante"] as? String
            pagado = dic!["pagado"] as? Bool
            
            //Agregar todos los datos necesarios del cellDatosMenu
            
            if pagado == true {
                
                let referenceImage1 = Storage.storage().reference().child("\(restaurante)/LogoBienvenida.png")
                
                referenceImage1.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
                    
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("ERROR AQUI: \(error.localizedDescription)")
                        
                        return ()
                        
                    } else { //Hubo exito
                        print("Hubo exito al bajar la imagen 1")
                        
                        imagenLogo = UIImage(data: data!)!
                        
                        let referenceImage2 = Storage.storage().reference().child("\(restaurante)/menuFondo.png")
                        
                        referenceImage2.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
                            
                            if let error = error {
                                // Uh-oh, an error occurred!
                                print("ERROR AQUI: \(error.localizedDescription)")
                                
                                return ()
                                
                            } else { //Hubo exito
                                print("Hubo exito al bajar la imagen 2")
                                
                                DispatchQueue.main.async {
                                    imagenFondo = UIImage(data: data!)
                                    
                                    let datosMenu = cellCollectionDatosMenu(imagenRestauranteFondo: imagenFondo!, textoRestaurante: restaurante, imagenLogo: imagenLogo!, descripcionRestaurante: descpRest!)
                                    
                                    self.restaurantesMenu.append(datosMenu)
                                    print(self.restaurantesMenu.count)
                                    
                                    self.collectionViewRestaurantes.reloadData()
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }else{
                
                print("El restaurante: \(restaurante) no será mostrado, por no haber pagado")
                
            }
        }
        
    }
    
    @objc func refrescarMenu(){
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
            self.viewCargando.alpha = 1
        }) { (finish) in
            self.restaurantesMenu.removeAll()
        }
        
        agarrarRestaurantes()
        
    }
    
    func configBtnRefrescar(){
        
        let compartirBtn:UIButton = UIButton.init(type: .custom)
        compartirBtn.setImage(#imageLiteral(resourceName: "Refrescar"), for: .normal)
        compartirBtn.addTarget(self, action: #selector(refrescarMenu), for: .touchUpInside)
        compartirBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let compartirBtnBar = UIBarButtonItem(customView: compartirBtn)
        
        self.navigationItem.setRightBarButton(compartirBtnBar, animated: false)
        
    }
    

}


extension Prueba2VC: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurantesMenu.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        SVProgressHUD.dismiss()
        
        if restaurantesMenu.count > 0{
            
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: {
                self.viewCargando.alpha = 0
                Database.database().reference()
            }, completion: nil)
            
        }
        
        let menuChingon = restaurantesMenu[indexPath.row]
        
        let cell = collectionViewRestaurantes.dequeueReusableCell(withReuseIdentifier: "restauranteCVCell", for: indexPath) as! RestauranteCVCell
        
        cell.setCell(menu: menuChingon)
        
        return cell
        
    }
    
    
    
    
}


extension Prueba2VC: UICollectionViewDelegate, UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionViewRestaurantes.collectionViewLayout as! UICollectionViewFlowLayout
        
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        
        targetContentOffset.pointee = offset
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionViewRestaurantes.cellForItem(at: indexPath)
        cell?.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        cell?.layer.borderWidth = 1
        
        indexPasar = indexPath
        Database.database().reference().child("restaurantes").removeAllObservers()
        performSegue(withIdentifier: "unwindSegueRestaurantes-Localizar", sender: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionViewRestaurantes.cellForItem(at: indexPath)
        cell?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell?.layer.borderWidth = 1
        
    }
    
    
    
    
}

























