//
//  PruebaInicioNuevoVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 30/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Auk
import Firebase
import SVProgressHUD
import CoreLocation


class searchResultss{
    var categoria:String?
    var restaurante:String?
    
    init(categoria:String, restaurante:String) {
        self.categoria = categoria
        self.restaurante = restaurante
    }
}


class PruebaInicioNuevoVC: UIViewController, CLLocationManagerDelegate{

    
    @IBOutlet weak var scrollViewImagenesInicio: UIScrollView!
    @IBOutlet weak var collectionViewCategoria: UICollectionView!
    @IBOutlet weak var collectionViewRecomRes: UICollectionView!
    @IBOutlet weak var labelMensajeDia: UILabel!
    @IBOutlet weak var viewCargando: UIView!
    
    
    var categoriasMostrar = [cellCategoriasDatos]()
    var recomRestaurantes = [cellRecomResDatos]()
    
    var restaurantesResultados = [searchResultss]()
    var filteredRestaurantes = [searchResultss]()
    
    var indexPasar:IndexPath?
    var collectionSeleccionado:Bool?
    
    let review = storeKitFunc()
    let hayInternet = checarInternetFunc()
    
    var searchController = UISearchController()
    var resultTableVC = UITableViewController()
    
    let locationManager = CLLocationManager()
    let userLocationBergas = CLLocation()
    
    
    let pruebaNombres = ["Hola", "Como", "Estas"]
    
    let funcionDia = Funciones()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupScrollViewImagenes()
        //setupDiaMensaje()
        
        if categoriasMostrar.count == 0{
            
            self.viewCargando.isHidden = false
            
        }
        
        
        fetchCategorias()
        configUserLocation()
        fetchResult()
        configSearchBar()
        review.showReview()
        
        collectionViewCategoria.delegate = self
        collectionViewCategoria.dataSource = self
        
        collectionViewRecomRes.delegate = self
        collectionViewRecomRes.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configNavBar()
        
        if hayInternet.isConnectedToNetwork() == true {
            
            print("Chido, hay internet")
            
        }else{
            
            let controller = UIAlertController(title: "No hay conexión a Internet", message: "Necesitas Internet para acceder a los menús", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            controller.addAction(ok)
            
            present(controller, animated: true, completion: nil)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let subviews = self.navigationController?.navigationBar.subviews else{return}
        for view in subviews{
            if view.tag == 1{
                view.removeFromSuperview()
            }
        }
    }
    
    func configNavBar(){
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.03137254902, alpha: 1)
        
        /*navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true*/
        
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Heavy", size: 36)!,
                                                                            NSAttributedStringKey.foregroundColor:UIColor.white]
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Medium", size: 21)!,
                                                                            NSAttributedStringKey.foregroundColor:UIColor.white]
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Medium", size: 21)!,
                                                                            NSAttributedStringKey.foregroundColor:UIColor.white]
        }
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationItem.hidesSearchBarWhenScrolling = false
            
            
        }
        
        
    }
    
    
    
    func configSearchBar(){
        
        searchController = UISearchController(searchResultsController: self.resultTableVC)
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = true
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            // Fallback on earlier versions
        }
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        //searchController.searchBar.sizeToFit()
        
        resultTableVC.tableView.delegate = self
        resultTableVC.tableView.dataSource = self
        
        resultTableVC.tableView.separatorStyle = .none
        
        
        
        //Custom SearchBar
        let searchControllerBar = searchController.searchBar
        searchControllerBar.placeholder = "Buscar Restaurante"
        searchControllerBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Buscar Restaurante", attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)])
        
        if let textfield = searchControllerBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            textfield.keyboardAppearance = .dark
            if let backgroundview = textfield.subviews.first {
                
                // Background color
                backgroundview.backgroundColor = UIColor.white
                
                // Rounded corner
                backgroundview.layer.cornerRadius = 10;
                backgroundview.clipsToBounds = true;
            }
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            
            
        }
        
    }
    
    //MARK: - Para la busqueda del searchController
    
    func fetchResult() {
        
        var arrayComboRestaurante:[searchResultss] = []
        
        Database.database().reference().child("restaurantes").child("categorias").observe(.childAdded) { (snapshot) in
            print("FetchResult: \(snapshot.key)")
            
            let categoria = snapshot.key
            Database.database().reference().child("restaurantes").child("categorias").child(categoria).observe(.childAdded, with: { (snapshot2) in
                
                print("RestauranteResults: \(snapshot2.key)")
                let combo = searchResultss(categoria: categoria, restaurante: snapshot2.key)
                arrayComboRestaurante.append(combo)
                self.fetchEmpezarBusqueda(arrayResultado: arrayComboRestaurante)
                print("Hay \(arrayComboRestaurante.count) restaurantes con categoria por buscar")
                
            })
            
        }
        
    }
    
    func fetchEmpezarBusqueda(arrayResultado:[searchResultss]){
        
        print("En fetchEmpezar hay \(arrayResultado.count) resultados")
        
        restaurantesResultados = arrayResultado
        
        print(restaurantesResultados)
        
    }
    
    //-------------------------------------
    
    func fetchCategorias(){
        
        Database.database().reference().child("restaurantes").child("categorias").observe(.childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            print("Categoria: \(snapshot.key)")
            
            let nombreCategoria = snapshot.key
            var imageFondoCategoria:UIImage?
            
            let referenciaImagenCategoria = Storage.storage().reference().child("categorias/\(nombreCategoria)/fondoCategoria.png")
            
            referenciaImagenCategoria.getData(maxSize: 1 * 2048 * 2048, completion: { (data, error) in
                
                if let err = error {
                    print("ERROR AQUI: \(err.localizedDescription)")
                    return()
                }else{
                    print("Hubo exito en bajar la imagen de fondo")
                    
                    if self.categoriasMostrar.count <= 6{
                        DispatchQueue.main.async {
                            imageFondoCategoria = UIImage(data: data!)
                            
                            let datosCategoria = cellCategoriasDatos(imagenCategoriaFondo: imageFondoCategoria!, nombreCategoria: nombreCategoria)
                            
                            self.categoriasMostrar.append(datosCategoria)
                            print("Hay \(self.categoriasMostrar.count) categorias")
                            
                            self.collectionViewCategoria.reloadData()
                        }
                    }else{
                        print("Son más de un elemento, ya no más")
                    }
                    
                    
                }
                
                
            })
            
        }
        
    }
    
    func fetchRecomRes(){
        
        
        Database.database().reference().child("restaurantes").child("recomendaciones").observeSingleEvent(of: .childAdded) { (snapshot) in
            
            let dicDatosRecom = snapshot.value as? [String:Any]
            
            let categoria = dicDatosRecom!["categoria"] as? String
            let fotoFondo = dicDatosRecom!["fotoFondo"] as? String
            let latitud = dicDatosRecom!["latitud"] as? Double
            let longitud = dicDatosRecom!["longitud"] as? Double
            let nombre = dicDatosRecom!["nombre"] as? String
            
            let coordenadasRestaurante = CLLocation(latitude: latitud!, longitude: longitud!)
            let coordenadasUsuario = self.userLocation()
            let distancia = coordenadasRestaurante.distance(from: coordenadasUsuario!)
            let distanciaKM = distancia/1000
            let distanceString:String = String(format:"%.02f", distanciaKM)
            
            let referenciaFotoFondo = Storage.storage().reference(forURL: fotoFondo!)
            
            referenciaFotoFondo.getData(maxSize: 1 * 2048 * 2048, completion: { (data, error) in
                
                if error != nil{
                    print("Hay un error al bajar la foto de Recom: \(String(describing: error?.localizedDescription))")
                }else{
                    DispatchQueue.main.async {
                        let imagenFondoBergas = UIImage(data: data!)
                        
                        let datosRecom = cellRecomResDatos(imagenRes: imagenFondoBergas!, nombreRes: nombre!, nombreCategoria: categoria!, distancia: distanceString)
                        
                        self.recomRestaurantes.append(datosRecom)
                        self.collectionViewRecomRes.reloadData()
                    }
                }
                
            })
            
        }
        
        
    }
    
    //MARK: - Funciones user's Location
    func userLocation() -> CLLocation? {
        
        let userLongitud = locationManager.location?.coordinate.longitude
        let userLatitud = locationManager.location?.coordinate.latitude
        
        let userCoordinates = CLLocation(latitude: userLatitud!, longitude: userLongitud!)
        return userCoordinates
        
        
    }
    
    
    func configUserLocation(){
        locationManager.requestWhenInUseAuthorization()
        
        let status = CLLocationManager.authorizationStatus()
        
        locationManager.startUpdatingLocation()
        
        if status == .authorizedWhenInUse{
            fetchRecomRes()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            fetchRecomRes()
        }
    }
    
    //-----------------------------------------------------------------
    
    //MARK: - Funciones Para Buscar y filtrar
    func filteredContentSearchBar(_ searchText:String, scope:String = "All"){
        
        filteredRestaurantes = restaurantesResultados.filter({ (res:searchResultss) -> Bool in
            return (res.restaurante?.lowercased().contains(searchText.lowercased()))!
        })
        
        resultTableVC.tableView.reloadData()
        
    }
    
    func searchBarEstaVacia() -> Bool{
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool{
        return searchController.isActive && !searchBarEstaVacia()
    }
    //-------------------------------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? Prueba2VC{
            destination.recibirCategoria = categoriasMostrar[(indexPasar?.row)!].nombreCategoria
        }else if let destinationMenu = segue.destination as? SeccionesVC{
            
            if collectionSeleccionado == false{
                destinationMenu.validarCategoria = recomRestaurantes[(indexPasar?.row)!].nombreCategoria
                destinationMenu.restauranteSeleccionado = recomRestaurantes[(indexPasar?.row)!].nombreRes
            }else if collectionSeleccionado == true{
                destinationMenu.validarCategoria = filteredRestaurantes[(indexPasar?.row)!].categoria
                destinationMenu.restauranteSeleccionado = filteredRestaurantes[(indexPasar?.row)!].restaurante
            }
            
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setupScrollViewImagenes(){
        
        scrollViewImagenesInicio.auk.startAutoScroll(delaySeconds: 6.0)
        scrollViewImagenesInicio.auk.settings.contentMode = .scaleAspectFill
        scrollViewImagenesInicio.auk.settings.pageControl.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        scrollViewImagenesInicio.auk.settings.pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 0.5764705882, blue: 0, alpha: 1)
        scrollViewImagenesInicio.auk.settings.placeholderImage = #imageLiteral(resourceName: "Empty")
        
        scrollViewImagenesInicio.layer.cornerRadius = 10.0
        
        let referenciaImagen1 = Storage.storage().reference().child("imagenesAvisos/1.png")
        
        referenciaImagen1.getData(maxSize: 1 * 2048 * 2048, completion: { (data, error) in
            
            if let err = error {
                print("ERROR AQUI: \(err.localizedDescription)")
                return()
            }else{
                print("Hubo exito en bajar la imagen de fondo")
                
                guard let imagen1 = UIImage(data: data!) else{return}
                
                self.scrollViewImagenesInicio.auk.show(image: imagen1)
                
            }
            
            
        })
        
        let referenciaImagen2 = Storage.storage().reference().child("imagenesAvisos/2.png")
        
        referenciaImagen2.getData(maxSize: 1 * 2048 * 2048, completion: { (data, error) in
            
            if let err = error {
                print("ERROR AQUI: \(err.localizedDescription)")
                return()
            }else{
                print("Hubo exito en bajar la imagen de fondo")
                
                guard let imagen2 = UIImage(data: data!) else{return}
                
                self.scrollViewImagenesInicio.auk.show(image: imagen2)
                
            }
            
            
        })
        
        
        
    }
    
    func setupDiaMensaje(){
        
        let horaDia = funcionDia.tenerHoraDelDia()
        
        switch horaDia {
        case "7":
            self.labelMensajeDia.text = "Hora de un rico desayuno"
        case "8":
            self.labelMensajeDia.text = "Hora de un rico desayuno"
        case "9":
            self.labelMensajeDia.text = "Hora de un rico desayuno"
        case "10":
            self.labelMensajeDia.text = "Hora de un rico desayuno"
        case "11":
            self.labelMensajeDia.text = "Hora de un rico desayuno"
        case "12":
            self.labelMensajeDia.text = "Planear a dónde ir a comer"
        case "13":
            self.labelMensajeDia.text = "Planear a dónde ir a comer"
        case "14":
            self.labelMensajeDia.text = "Planear a dónde ir a comer"
        case "15":
            self.labelMensajeDia.text = "Planear a dónde ir a comer"
        case "16":
            self.labelMensajeDia.text = "Planear a dónde ir a comer"
        case "17":
            self.labelMensajeDia.text = "Tarde perfecta para ir a comer"
        case "18":
            self.labelMensajeDia.text = "Tarde perfecta para ir a comer"
        case "19":
            self.labelMensajeDia.text = "Tarde perfecta para ir a comer"
        case "20":
            self.labelMensajeDia.text = "Una rica cena no vendría mal"
        case "21":
            self.labelMensajeDia.text = "Una rica cena no vendría mal"
        case "22":
            self.labelMensajeDia.text = "Una rica cena no vendría mal"
        case "23":
            self.labelMensajeDia.text = "Todavía tienes tiempo para ir por cena, ¡checa rápido el menú!"
        default:
            self.labelMensajeDia.text = "Es muy tarde, pero no tarde para ir por cenar."
        }
        
        UIView.animate(withDuration: 2, delay: 0, options: .transitionCurlUp, animations: {
            self.labelMensajeDia.alpha = 1
        }, completion: nil)
        
    }
    

}



extension PruebaInicioNuevoVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategoria{
            return categoriasMostrar.count
        }else{
            return recomRestaurantes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionViewCategoria{
            let categoriaChingona = categoriasMostrar[indexPath.row]
            
            if categoriasMostrar.count > 0 || scrollViewImagenesInicio.auk.images.count > 0{
             
             UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: {
             self.viewCargando.alpha = 0
             }, completion: nil)
             
             }
            
            let cell = collectionViewCategoria.dequeueReusableCell(withReuseIdentifier: "cellPruebaCategoria", for: indexPath) as! PruebaCVCell
            
            cell.setCell(categoria: categoriaChingona)
            
            SVProgressHUD.dismiss()
            
            return cell
        }else{
            let recomChingona = recomRestaurantes[indexPath.row]
            
            let cell = collectionViewRecomRes.dequeueReusableCell(withReuseIdentifier: "cellRecom", for: indexPath) as! RecomrestaurantesCVCell
            
            cell.setCell(dato: recomChingona)
            
            return cell
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == collectionViewRecomRes{
            
            print("Entro en false")
            indexPasar = indexPath
            collectionSeleccionado = false
            
            Database.database().reference().child("restaurantes").child("categorias").removeAllObservers()
            
            performSegue(withIdentifier: "segueQuickMenu-Secciones", sender: nil) //Ojo
            
            collectionView.deselectItem(at: indexPath, animated: true)
            
        }else{
            
            print("Entro en true")
            indexPasar = indexPath
            
            Database.database().reference().child("restaurantes").child("categorias").removeAllObservers()
            
            performSegue(withIdentifier: "segueQuickMenu-Categoria", sender: nil) //Ojo
            
            collectionView.deselectItem(at: indexPath, animated: true)
        }
        
        
        
    }
    
    
    
    
}



extension PruebaInicioNuevoVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentSearchBar(searchController.searchBar.text!)
    }
}


extension PruebaInicioNuevoVC : UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering(){
            if filteredRestaurantes.count == 0{
                let imageFondoView : UIImageView = {
                    let iv = UIImageView()
                    iv.image = UIImage(named:"Empty Results")
                    iv.contentMode = .scaleAspectFill
                    iv.clipsToBounds = true
                    return iv
                }()
                self.resultTableVC.tableView.backgroundView = imageFondoView
                return filteredRestaurantes.count
            }else{
                self.resultTableVC.tableView.backgroundView = nil
                return filteredRestaurantes.count
            }
        }
        
        return restaurantesResultados.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell()
        let cell = Bundle.main.loadNibNamed("SearchResultsTVCell", owner: self, options: nil)?.first as! SearchResultsTVCell
        cell.selectionStyle = .none
        
        let searchRes:searchResultss
        
        if isFiltering(){
            searchRes = filteredRestaurantes[indexPath.row]
        }else{
            searchRes = restaurantesResultados[indexPath.row]
        }
        
        /*cell.textLabel?.text = searchRes.restaurante
         cell.detailTextLabel?.text = searchRes.categoria*/
        
        cell.labelRestaurante.text = searchRes.restaurante
        cell.labelCategoria.text = searchRes.categoria
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        indexPasar = indexPath
        collectionSeleccionado = true
        
        /*let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
         selectedCell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)*/
        
        performSegue(withIdentifier: "segueQuickMenu-Secciones", sender: nil) //Ojo
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}



























