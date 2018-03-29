//
//  AgarrarMenuVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 25/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class AgarrarMenuVC: UIViewController {

    
    @IBOutlet weak var tableViewMenu: UITableView!
    @IBOutlet weak var viewCargandoContenido: UIView!
    
    
    var restaurantesMenu = [cellDatosMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if restaurantesMenu.count == 0{
            
            self.viewCargandoContenido.isHidden = false
            
        }
        
        configNavBar()
        agarrarRestaurantes()
        
    }

    

    func agarrarRestaurantes(){
        
        Database.database().reference().child("restaurantes").observeSingleEvent(of: .childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            print(snapshot.key)
            let restaurante = snapshot.key
            var imagenLogo:UIImage?
            var imagenFondo:UIImage?
            //Agregar todos los datos necesarios del cellDatosMenu
            
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
                                
                                let datosMenu = cellDatosMenu(imagenFondo: imagenFondo!, textoRest: restaurante, imagenLogo: imagenLogo!)
                                
                                self.restaurantesMenu.append(datosMenu)
                                print(self.restaurantesMenu.count)
                                
                                self.tableViewMenu.reloadData()
                            }
                            
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func configNavBar(){
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Restaurantes"
        
        configSearchBar()
        configBtnRefrescar()
        
    }
    
    @objc func refrescarMenu(){
    
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
            self.viewCargandoContenido.alpha = 1
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
    
    func configSearchBar(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Buscar Restaurante"
        searchController.searchBar.tintColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        
    }
    

}

extension AgarrarMenuVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantesMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        SVProgressHUD.dismiss()
        
        if restaurantesMenu.count > 0{
            
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: {
                self.viewCargandoContenido.alpha = 0
                Database.database().reference()
            }, completion: nil)
            
        }
        
        let menuChingon = restaurantesMenu[indexPath.row]
        
        let cell = tableViewMenu.dequeueReusableCell(withIdentifier: "cellMenuGrosero") as! MenusTVCell
        
        cell.setCell(menu: menuChingon)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "unwindSegue-LocalizarRestaurante", sender: nil)
        tableViewMenu.deselectRow(at: indexPath, animated: true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? LocalizarRestauranteVC {
            destination.textFieldRestaurante.text = restaurantesMenu[(tableViewMenu.indexPathForSelectedRow?.row)!].textoRest
        }
    }
    
    
    
}

























































