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

class PlatilloSeleccionadoTVC: UITableViewController {

    @IBOutlet weak var imageViewPlatillos: UIImageView!
    @IBOutlet weak var labelNombrePlatillo: UILabel!
    @IBOutlet weak var labelDescripcionPlatillo: UILabel!
    @IBOutlet weak var labelPrecio: UILabel!
    
    var platilloSeleccionado:String?
    var restauranteSeleccionado:String?
    var seccionSeleccionada:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configNavBar()
        queryDetallesPlatillo()
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
        
    }
    

}























