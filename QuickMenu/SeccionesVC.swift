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
    
    @IBOutlet var viewPromocionRestaurante: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var scrollviewPromos: UIScrollView!
    @IBOutlet weak var imagenFondoPromo: UIImageView!
    
    let funcionesUtiles = Funciones()
    
    var restauranteSeleccionado:String?
    
    var datosSeccion = DatosSeccion()
    
    lazy var array = [cellDatos]()
    
    var seccionRegresar:cellDatos?
    
    var urlImagen:String?
    
    var effect:UIVisualEffect!
    
    var telefonoRestaurante = String()
    var horarioRestaurante = String()
    
    var validarCategoria:String?
    
    var vistoRecientes:datosVistoRecientemente?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configNavBar()
        
        //Config. PromoView
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        viewPromocionRestaurante.layer.cornerRadius = 5
        imagenFondoPromo.layer.cornerRadius = 5
        
        //-------------------------------------------
        
        // Do any additional setup after loading the view.
        if datosSeccion.arrayCellData.count == 0 {
            
            viewTVCVacio.isHidden = false
            
        }
        
        setupElementos()
        
        labelRestauranteFondo.text = restauranteSeleccionado
        
        configImagenesBienvenida(restauranteSeleccionado!)
        
        queryDatosSeccion(validarCategoria!, restauranteSeleccionado!)
        
        fetchHorario(validarCategoria!, restauranteSeleccionado!)
        
        //Delay para la aparicion de las promociones
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            self.setupAnimacionPromocion()
        })
        
        //guardarVistoRecientemente()
        
        
    }
    
    func guardarVistoRecientemente(){
        
        let restauranteVisto = restauranteSeleccionado
        let categoriaVisto = validarCategoria
        
        let datosVistos = datosVistoRecientemente(categoria: categoriaVisto!, restaurante: restauranteVisto!)
        
        var arrayVisto = [datosVistoRecientemente]()
        arrayVisto.append(datosVistos)
        
        
        if UserDefaults.standard.array(forKey: "vistoReciente") != nil{
            print("Existe un array de vistoRecientemente")
            
            if var arrayVistoReciente2 = UserDefaults.standard.array(forKey: "vistoReciente") as? [datosVistoRecientemente]{
                print("Se creó el array de vistoRecientemente")
                
                let hayRepetido = arrayVistoReciente2.contains(where: { (str) -> Bool in
                    if str.restaurante == restauranteVisto && str.categoria == categoriaVisto{
                        return true
                    }
                    return false
                })
                
                if hayRepetido == true{
                    print("----Hay elemento repetido para visto recientes----")
                }else{
                    print("Se agregó nuevo elemento de visto Recientemente")
                    arrayVistoReciente2.append(datosVistos)
                    UserDefaults.standard.set(arrayVistoReciente2, forKey: "vistoReciente")
                }
                
            }
            
        }else{
            
            print("Se creó nuevo array de vistoRecientemente")
            UserDefaults.standard.set(arrayVisto, forKey: "vistoReciente")
            
        }
        
    }
    
    
    func queryDatosSeccion(_ categoriaSeleccionada:String, _ restauranteSeleccinado:String) {
        
        Database.database().reference().child("restaurantes").child("categorias").child(categoriaSeleccionada).child(restauranteSeleccinado).child("menu").observe(.childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            let seccion = [snapshot.key]
            print("\(seccion) en queryDatosSeccion")
            
            
            for key in seccion {
                
                print(seccion, "En descargar Imagenes")
                
                //Aquí nos enfocaremos para que saque todas las imagenes de las secciones, luego hacer de descargar varias imagenes, y desplegarlas
                let referenceImage = Storage.storage().reference().child("\(restauranteSeleccinado)/secciones/\(key)/\(key).jpg")
                
                referenceImage.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
                    
                    if let error = error {
                        // Uh-oh, an error occurred!
                        print("ERROR AQUI: \(error.localizedDescription)")
                        
                        //Segue para la eleccion del menu
                        self.performSegue(withIdentifier: "unwindSegueBuscarRestaurante", sender: self)
                        SVProgressHUD.showError(withStatus: "No se pudo cargar el menú completo, intentar más tarde este menú")
                        return ()
                        
                    } else { //Hubo exito
                        
                        DispatchQueue.main.async {
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
            
        }
        
        
        
    }
    
    func fetchHorario(_ categoriaSeleccionada:String, _ resSeleccionada:String){
        
        Database.database().reference().child("restaurantes").child("categorias").child(categoriaSeleccionada).child(resSeleccionada).child("horario").observeSingleEvent(of: .value) { (snapshot) in
            
            if let horario = snapshot.value as? String{
                
                self.horarioRestaurante = horario
                
            }
            
        }
        
    }
    
    //MARK: - Config. Imagenes de fondo en la bienvenida
    
    func configImagenesBienvenida(_ resSeleccionado:String){
        
        scrollView.auk.settings.contentMode = .scaleAspectFill
        scrollView.auk.settings.pageControl.visible = false
        scrollView.auk.startAutoScroll(delaySeconds: 6.0)
        
        let referenceImage = Storage.storage().reference().child("\(resSeleccionado)/RestauranteFondo/1.jpg")
        
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
        
        let referenceImage2 = Storage.storage().reference().child("\(resSeleccionado)/RestauranteFondo/2.jpg")
        
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
        
        let referenceImage3 = Storage.storage().reference().child("\(resSeleccionado)/RestauranteFondo/3.jpg")
        
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
        
        let referenceImage4 = Storage.storage().reference().child("\(resSeleccionado)/LogoBienvenida.png")
        
        referenceImage4.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return ()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.imageLogoRestaurante.layer.borderWidth = 2
                self.imageLogoRestaurante.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                self.imageLogoRestaurante.image = imagen
                
            }
            
        }
        
    }
    
    //------------------------------------------------------------------------------------------

    
    
    //MARK: - Config. NavBar
    
    func configNavBar() {
        
        navigationItem.title = "Menú"
        
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .always
        }
        
        let compartirBtn:UIButton = UIButton.init(type: .custom)
        compartirBtn.setImage(#imageLiteral(resourceName: "Mapa"), for: .normal)
        compartirBtn.addTarget(self, action: #selector(irAMapa), for: .touchUpInside)
        compartirBtn.frame = CGRect(x: 0, y: 0, width: 20, height: 24)
        let compartirBtnBar = UIBarButtonItem(customView: compartirBtn)
        
        let llamarBtn:UIButton = UIButton.init(type: .custom)
        llamarBtn.setImage(#imageLiteral(resourceName: "TelefonoChido"), for: .normal)
        llamarBtn.addTarget(self, action: #selector(llamarRestaurante), for: .touchUpInside)
        llamarBtn.frame = CGRect(x: 0, y: 0, width: 26, height: 26)
        let llamarBtnBar = UIBarButtonItem(customView: llamarBtn)
        
        let horarioBtn:UIButton = UIButton.init(type: .custom)
        horarioBtn.setImage(#imageLiteral(resourceName: "Horario"), for: .normal)
        horarioBtn.addTarget(self, action: #selector(mostrarHorario), for: .touchUpInside)
        horarioBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let horarioBarBtn = UIBarButtonItem(customView: horarioBtn)
        
        let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace.width = 20.0
        
        let fixedSpace2:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        fixedSpace2.width = 17.0
        
        Database.database().reference().child("restaurantes").child("categorias").child(validarCategoria!).child(restauranteSeleccionado!).child("numeroTelefonico").observeSingleEvent(of: .value) { (snapshot) in
            
            if let telefono = snapshot.value as? String {
                
                print("Telefono: \(telefono)")
                
                self.navigationItem.setRightBarButtonItems([compartirBtnBar, fixedSpace, llamarBtnBar, fixedSpace2, horarioBarBtn], animated: false)
                
                self.telefonoRestaurante = telefono
                
            }else{
                
                self.navigationItem.setRightBarButtonItems([compartirBtnBar, fixedSpace, horarioBarBtn], animated: false)
                
            }
            
        }
        
        //Dependiendo del restaurante, sacar de la base de datos, el color correspondiente
        
        //navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        Database.database().reference().child("restaurantes").child("categorias").child(validarCategoria!).child(restauranteSeleccionado!).child("mainHexColor").observeSingleEvent(of: .value) { (snapshot) in
            
            if let color = snapshot.value as? String {
                
                print("El color sacado de la base de datos es: \(color)")
                
                let colorAplicar = UIColor().colorFromHex(color)
                
                UIView.animate(withDuration: 1, animations: {
                    self.navigationController?.navigationBar.barTintColor = colorAplicar
                    self.navigationController?.navigationBar.layoutIfNeeded()
                })
                
            }else{
                print("No se sacó ningun color de la base de datos")
            }
            
        }
        
       
        
        
    }
    
    @objc func irAMapa(){
        
        
        performSegue(withIdentifier: "segue-direccionRestaurante", sender: nil)
        
        
    }
    
    @objc func llamarRestaurante(){
        
        
        if let urlTel = URL(string: "tel://\(telefonoRestaurante)"){
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(urlTel, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
            
            
        }
        
    }
    
    @objc func mostrarHorario(){
        
        print("Mostrando horario")
        
        let alertController = UIAlertController(title: "Horarios de \(restauranteSeleccionado!)", message: horarioRestaurante, preferredStyle: .alert)
        
        let okey = UIAlertAction(title: "OK", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(okey)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
  
    @IBAction func btnFBAction(_ sender: UIButton) {
        
        print("Boton FB presionado")
        
        Database.database().reference().child("restaurantes").child("categorias").child(validarCategoria!).child(restauranteSeleccionado!).child("facebookURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
               
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    guard let urlFacebook = URL(string: url) else {return}
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlFacebook, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(urlFacebook)
                    }
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "El restaurante no tiene pagina de Facebook, intenta con otra red social")
                    
                }
                
                
            }
            
            
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
        
        
    }
    
    @IBAction func btnTripAction(_ sender: UIButton) {
        
        print("Boton Trip presionado")
        
        Database.database().reference().child("restaurantes").child("categorias").child(validarCategoria!).child(restauranteSeleccionado!).child("tripAdvisorURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
                
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    guard let urlTripAdvisor = URL(string: url) else {return}
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlTripAdvisor, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(urlTripAdvisor)
                    }
                    
                }else{
                    
                    SVProgressHUD.showError(withStatus: "El restaurante no tiene pagina de TripAdvisor, intenta con otra red social")
                    
                }
                
                
            }
            
            
        }
        
        SVProgressHUD.dismiss(withDelay: 1.0)
        
    }
    
    @IBAction func btnTwitterAction(_ sender: UIButton) {
        
        print("Boton Instagram presionado")
        
        Database.database().reference().child("restaurantes").child("categorias").child(validarCategoria!).child(restauranteSeleccionado!).child("instagramURL").observeSingleEvent(of: .value) { (snapshot) in
            
            if let url = snapshot.value as? String {
                
                if url != "" {
                    
                    print(url)
                    
                    SVProgressHUD.show()
                    
                    guard let urlInstagram = URL(string: url) else {return}
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(urlInstagram, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        UIApplication.shared.openURL(urlInstagram)
                    }
                    
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
    
    //Config. Animaciones de la vista de promociones
    
    func setupAnimacionPromocion(){
        
        let diaActual = funcionesUtiles.tenerDiaDeLaSemana()
        scrollviewPromos.auk.settings.contentMode = .scaleAspectFill
        scrollviewPromos.auk.settings.pageControl.visible = false
        scrollviewPromos.isUserInteractionEnabled = false //AQUI DESACTIVAR LUEGO
        scrollviewPromos.auk.settings.placeholderImage = #imageLiteral(resourceName: "Logo Empty")
        let referenceImagePromo1 = Storage.storage().reference().child("\(restauranteSeleccionado!)/Promociones/\(diaActual!)/1.jpg")
        
        referenceImagePromo1.getData(maxSize: 1 * 2048 * 2048) { (data, error) in
            
            if let error = error {
                // Uh-oh, an error occurred!
                print("ERROR AQUI: \(error.localizedDescription)")
                
                return()
                
            } else { //Hubo exito
                print("Hubo exito al bajar la imagen 1")
                
                let imagen = UIImage(data: data!)
                
                self.scrollviewPromos.auk.show(image: imagen!)
                
                self.view.addSubview(self.viewPromocionRestaurante)
                self.viewPromocionRestaurante.center = self.visualEffectView.center
                self.viewPromocionRestaurante.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                self.viewPromocionRestaurante.alpha = 0
                
                UIView.animate(withDuration: 0.4) {
                    
                    self.visualEffectView.isHidden = false
                    self.visualEffectView.effect = self.effect
                    self.viewPromocionRestaurante.alpha = 1
                    self.viewPromocionRestaurante.transform = CGAffineTransform.identity
                    
                }
                
            }
            
        }
    
        
    }
    
    
    func setupAnimacionPromocionOut(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewPromocionRestaurante.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.viewPromocionRestaurante.alpha = 0
            self.visualEffectView.effect = nil
        }) { (success) in
            self.viewPromocionRestaurante.removeFromSuperview()
            self.visualEffectView.isHidden = true
        }
        
    }
    
    @IBAction func btnQuitarVistaPromo(_ sender: Any) {
        
        setupAnimacionPromocionOut()
        
    }
    
    //-----------------------------------------------------------------------------------------------------------
    

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
                Database.database().reference().child("restaurantes").child("categorias").child(self.validarCategoria!).child(self.restauranteSeleccionado!).child("menu").removeAllObservers()
                self.labelRestauranteFondo.alpha = 1
                self.labelOpinion.alpha = 1
            }, completion: { (success) in
                
            })
            
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
            destination.categoriaRecibida2 = validarCategoria
        }else if let destinationMapa = segue.destination as? MapaDireccionRestauranteVC {
            
            destinationMapa.restauranteSeleccionado = restauranteSeleccionado
            destinationMapa.categoriaSeleccionada = validarCategoria
            
        }
    }
    
    //-------------------------------------------------------------------------------------------
    
    
}























