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
import Auk


class SeccionesVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var tableViewSecciones: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var viewTVCVacio: UIView!
    @IBOutlet weak var labelRestauranteFondo: UILabel!
    @IBOutlet weak var labelCompartir: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var labelOpinion: UILabel!
    @IBOutlet weak var btnFB: UIButton!
    @IBOutlet weak var btnTrip: UIButton!
    @IBOutlet weak var btnTwitter: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageLogoRestaurante: UIImageView!
    
    var restauranteSeleccionado:String?
    
    var datosSeccion = DatosSeccion()
    
    lazy var array = [cellDatos]()
    
    var seccionRegresar:cellDatos?
    
    var urlImagen:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar()
        
        // Do any additional setup after loading the view.
        if datosSeccion.arrayCellData.count == 0 {
            
            viewTVCVacio.isHidden = false
            
        }
        
        setupElementos()
        
        labelRestauranteFondo.text = restauranteSeleccionado
        
        configImagenesBienvenida()
        queryDatosSeccion()
        
        
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }*/
    
    
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
     
        
    }
    
    //MARK: - Config. Imagenes de fondo en la bienvenida
    
    func configImagenesBienvenida(){
        
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.visible = false
        scrollView.auk.startAutoScroll(delaySeconds: 6.0)
        
        let referenceImage = Storage.storage().reference().child("\(restauranteSeleccionado!)/RestauranteFondo/1.jpg")
        
        referenceImage.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        let referenceImage2 = Storage.storage().reference().child("\(restauranteSeleccionado!)/RestauranteFondo/2.jpg")
        
        referenceImage2.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        let referenceImage3 = Storage.storage().reference().child("\(restauranteSeleccionado!)/RestauranteFondo/3.jpg")
        
        referenceImage3.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.scrollView.auk.show(image: imagen!)
                
            }
            
        }
        
        let referenceImage4 = Storage.storage().reference().child("\(restauranteSeleccionado!)/LogoBienvenida.png")
        
        referenceImage4.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.imageLogoRestaurante.image = imagen
                
            }
            
        }
        
    }
    
    //------------------------------------------------------------------------------------------

    
    
    //MARK: - Config. NavBar
    
    func configNavBar() {
        
        navigationItem.title = "Menú"
        
        //Dependiendo del restaurante, sacar de la base de datos, el color correspondiente
        
        //navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("colorNavBar").observeSingleEvent(of: .value) { (snapshot) in
            
                if let color = snapshot.value as? String {
            
                    print("El color sacado de la base de datos es: \(color)")
                    
                    let colorAplicar = UIColor(named: color)
                    
                    UIView.animate(withDuration: 2, animations: {
                        self.navigationController?.navigationBar.barTintColor = colorAplicar
                    })
            
                }else{
                    print("No se sacó ningun color de la base de datos")
                }
            
        }
        
        
        /*Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("colorBackground").observeSingleEvent(of: .value) { (snapshot) in
            
            if let colorBackground = snapshot.value as? String {
                
                print("El color de fondo sacado de la base de datos es: \(colorBackground)")
                
                let aplicarColor = UIColor(named: colorBackground)
                
                self.tableViewSecciones.backgroundColor = aplicarColor
                
            }else {
                
                print("No se sacó ningun color de la base de datos")
                
            }
            
        }*/
        
        
    }
    
  
    @IBAction func btnFBAction(_ sender: UIButton) {
        
        print("Boton FB presionado")
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("facebookURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
               
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    let urlFacebook = URL(string: url)
                    
                    UIApplication.shared.open(urlFacebook!, options: [:], completionHandler: nil)
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "El restaurante no tiene pagina de Facebook, intenta con otra red social")
                    
                }
                
                
            }
            
            
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
        
        
    }
    
    @IBAction func btnTripAction(_ sender: UIButton) {
        
        print("Boton Trip presionado")
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("tripAdvisorURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
                
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    let urlTripAdvisor = URL(string: url)
                    
                    UIApplication.shared.open(urlTripAdvisor!, options: [:], completionHandler: nil)
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "El restaurante no tiene pagina de TripAdvisor, intenta con otra red social")
                    
                }
                
                
            }
            
            
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnTwitterAction(_ sender: UIButton) {
        
        print("Boton Instagram presionado")
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("instagramURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
                
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    let urlInstagram = URL(string: url)
                    
                    UIApplication.shared.open(urlInstagram!, options: [:], completionHandler: nil)
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "El restaurante no tiene pagina de Instagram, intenta con otra red social")
                    
                }
                
                
            }
            
            
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    
    
    
    func setupElementos(){
        
        scrollView.alpha = 0
        labelRestauranteFondo.alpha = 0
        labelCompartir.alpha = 0
        labelOpinion.alpha = 0
        btnFB.alpha = 0
        btnTrip.alpha = 0
        btnTwitter.alpha = 0
        imageLogoRestaurante.alpha = 0
        
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
                self.labelRestauranteFondo.alpha = 1
                self.labelOpinion.alpha = 1
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 0.5, options: .transitionCrossDissolve, animations: {
                
                self.btnFB.alpha = 1
                self.btnTrip.alpha = 1
                self.btnTwitter.alpha = 1
                
            }, completion: nil)
            
            UIView.animate(withDuration: 1, delay: 1, options: .transitionCrossDissolve, animations: {
                self.scrollView.alpha = 1
                self.labelCompartir.alpha = 1
                self.imageLogoRestaurante.alpha = 1
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























