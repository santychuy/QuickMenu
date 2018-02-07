//
//  SeccionesVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 30/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class SeccionesVC: UIViewController {
    
    @IBOutlet weak var tableViewSecciones: UITableView!
    @IBOutlet weak var viewTVCVacio: UIView!
    @IBOutlet weak var imageRestauranteFondo: UIImageView!
    @IBOutlet weak var labelRestauranteFondo: UILabel!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var labelCompartir: UILabel!
    
    var restauranteSeleccionado:String?
    
    var datosSeccion = DatosSeccion()
    
    lazy var array = [cellDatos]()
    
    var seccionRegresar:cellDatos?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if datosSeccion.arrayCellData.count == 0 {
            
            viewTVCVacio.isHidden = false
            
        }
        
        setupElementos()
        
        labelRestauranteFondo.text = restauranteSeleccionado
        
        queryDatosSeccion()
        
        configNavBar()
        
        //El pedo ahorita es que no pasa nada a la hora de poner las tableViews, los datos no pasa nada
        
        
    }
    
    func queryDatosSeccion() {
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("menu").observe(.childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            let seccion = [snapshot.key]
            print("\(seccion) en queryDatosSeccion")
            
            
            for key in seccion {
                
                print(seccion, "En descargar Imagenes")
                
                //Aquí nos enfocaremos para que saque todas las imagenes de las secciones, luego hacer de descargar varias imagenes, y desplegarlas
                let referenceImage = Storage.storage().reference().child("\(self.restauranteSeleccionado!)/secciones/\(key)/\(key).jpg")
                
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
                        
                        let seccionn = cellDatos(textoSeccion: key, imagenSeccion: imagen!)
                        
                        //self.datosSeccion.arrayCellData.append(seccion)
                        self.datosSeccion.arrayCellData.append(seccionn)
                        //self.array?.append(seccionn)
                        
                        print(seccionn.textoSeccion!)
                        print(seccionn.imagenSeccion!)
                        print(self.datosSeccion.arrayCellData.count)
                        
                        self.tableViewSecciones.reloadData()
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("menu").removeAllObservers()
     
        //Aquí nos enfocaremos para que saque todas las imagenes de las secciones, luego hacer de descargar varias imagenes, y desplegarlas
        let referenceImage = Storage.storage().reference().child("\(restauranteSeleccionado!)/RestauranteFondo/\(restauranteSeleccionado!).jpg")
        
        referenceImage.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                
                let imagen = UIImage(data: data!)
                
                self.imageRestauranteFondo.image = imagen
                
            }
            
        }
        
        
    }

    
    //MARK: - Config. NavBar
    
    func configNavBar() {
        
        navigationItem.title = "Menú"
        
    }
    
    @IBAction func btnTwitterAction(_ sender: Any) {
    }
    
    @IBAction func btnTripAction(_ sender: Any) {
    }
    
    @IBAction func btnFBAction(_ sender: Any) {
    }
    
    
    func setupElementos(){
        
        imageRestauranteFondo.alpha = 0
        labelRestauranteFondo.alpha = 0
        btnTwitter.alpha = 0
        btnFB.alpha = 0
        btnTrip.alpha = 0
        labelCompartir.alpha = 0
        
    }
    

}




extension SeccionesVC: UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Funciones para TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Hay \(datosSeccion.arrayCellData.count) elementos ya dentro del tableView")
        return (datosSeccion.arrayCellData.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let seccionChingona = datosSeccion.arrayCellData[indexPath.row]
        
        let cell = tableViewSecciones.dequeueReusableCell(withIdentifier: "cellSeccion") as! SeccionTVCell
        
        cell.setSeccion(seccion: seccionChingona)
        
        SVProgressHUD.dismiss()
        
        
        if datosSeccion.arrayCellData.count > 0 {
            
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations: {
                self.viewTVCVacio.alpha = 0
                self.btnTwitter.alpha = 1
                self.btnFB.alpha = 1
                self.btnTrip.alpha = 1
                self.labelCompartir.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0.5, options: .transitionCrossDissolve, animations: {
                self.imageRestauranteFondo.alpha = 1
                self.labelRestauranteFondo.alpha = 1
                
            }, completion: nil)
            
            
            
        }
        
        let backgroundColor = UIView()
        backgroundColor.backgroundColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
        cell.selectedBackgroundView = backgroundColor
        
        
        return cell
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 343
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueSeccion-SeccionSeleccionada", sender: nil)
        tableViewSecciones.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? SeccionSeleccionadaVC {
            destination.seccionSeleccionada = datosSeccion.arrayCellData[(tableViewSecciones.indexPathForSelectedRow?.row)!].textoSeccion
            destination.restauranteSeleccionado = restauranteSeleccionado
        }
    }
    
    //-------------------------------------------------------------------------------------------
    
    
}























