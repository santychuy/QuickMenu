//
//  BuscarRestauranteVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 20/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 60
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Small NavBar state
    static let ImageBottomMarginForSmallState: CGFloat = 6
    /// Image height/width for Small NavBar state
    static let ImageSizeForSmallState: CGFloat = 35
    /// Height of NavBar for Small state. Usually it's just 44
    static let NavBarHeightSmallState: CGFloat = 44
    /// Height of NavBar for Large state. Usually it's just 96.5 but if you have a custom font for the title, please make sure to edit this value since it changes the height for Large state of NavBar
    static let NavBarHeightLargeState: CGFloat = 96.5
}

class searchResults{
    var categoria:String?
    var restaurante:String?
    
    init(categoria:String, restaurante:String) {
        self.categoria = categoria
        self.restaurante = restaurante
    }
}

class BuscarRestauranteVC: UIViewController, GADBannerViewDelegate {

    
    let imageView = UIImageView(image: UIImage(named: "Logo1"))
    
    @IBOutlet weak var collectionViewCategorias: UICollectionView!
    @IBOutlet weak var viewADPrincipio: GADBannerView!
    @IBOutlet weak var viewCargando: UIView!
    
    var categoriasMostrar = [cellCategoriasDatos]()
    
    var restaurantesResultados = [searchResults]()
    var filteredRestaurantes = [searchResults]()
    
    var indexPasar:IndexPath?
    
    let review = storeKitFunc()
    let hayInternet = checarInternetFunc()
    
    var searchController = UISearchController()
    var resultTableVC = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if categoriasMostrar.count == 0{
            
            self.viewCargando.isHidden = false
            
        }
        
        //Darle el fondo al collectionView
        let imageFondoView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named:"FondoPrin")
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            return iv
        }()
        
        
        collectionViewCategorias.backgroundView = imageFondoView
        //-------------------------------------
        
        imageView.tag = 1
        
        
        cargarAd()
        collectionViewCategorias.delegate = self
        collectionViewCategorias.dataSource = self
        
        fetchCategorias()
        fetchVistoRecientes()
        fetchResult()
        
        configSearchBar()
        
        review.showReview()  //Quitarlo despues
        
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
    
    func cargarAd(){
        
        let request = GADRequest()
        request.testDevices = ["b0b4b49615fe4f20dec0ed0643b80e67"]
        
        viewADPrincipio.adUnitID = "ca-app-pub-7391736686492116/7488313608"
        viewADPrincipio.rootViewController = self
        viewADPrincipio.delegate = self
        
        viewADPrincipio.load(request)
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        viewADPrincipio.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromTop, animations: {
            self.viewADPrincipio.alpha = 1
        }, completion: nil)
        
    }
    
    
    func configNavBar(){
        
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.03137254902, alpha: 1)
        
        
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
            
            //Para darle el efecto al logo
            guard let navigationBar = self.navigationController?.navigationBar else { return }
            imageView.alpha = 0
            navigationBar.addSubview(imageView)
            UIView.animate(withDuration: 1, animations: {
                self.imageView.alpha = 1
            })
            imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
            imageView.clipsToBounds = true
            imageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor,
                                                 constant: -Const.ImageRightMargin),
                imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor,
                                                  constant: -Const.ImageBottomMarginForLargeState),
                imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
                imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
                ])
            
            //------------------------------------
            
        }
        
        
    }
    
    //MARK: - Funciones para darle el efecto al logo a la hora que se deslice la pantalla
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)
        
        imageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
    }
    
    
    
    //-----------------------------------
    
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? Prueba2VC{
            destination.recibirCategoria = categoriasMostrar[(indexPasar?.row)!].nombreCategoria
        }else if let destinationMenu = segue.destination as? SeccionesVC{
            destinationMenu.validarCategoria = filteredRestaurantes[(indexPasar?.row)!].categoria
            destinationMenu.restauranteSeleccionado = filteredRestaurantes[(indexPasar?.row)!].restaurante
        }
        
    }
    
    
    func fetchVistoRecientes(){
        
        if UserDefaults.standard.array(forKey: "vistoReciente") != nil{
            
            if let arrayVisto = UserDefaults.standard.array(forKey: "vistoReciente") as? [datosVistoRecientemente]{
                
                print("Hay \(arrayVisto.count) elementos en el array")
                
            }
            
        }else{
            print("No existe el array, por ahora")
        }
        
    }
    
    //MARK: - Para la busqueda del searchController
    
    func fetchResult() {
        
        var arrayComboRestaurante:[searchResults] = []
        
        Database.database().reference().child("restaurantes").child("categorias").observe(.childAdded) { (snapshot) in
            print("FetchResult: \(snapshot.key)")
            
            let categoria = snapshot.key
            Database.database().reference().child("restaurantes").child("categorias").child(categoria).observe(.childAdded, with: { (snapshot2) in
                
                print("RestauranteResults: \(snapshot2.key)")
                let combo = searchResults(categoria: categoria, restaurante: snapshot2.key)
                arrayComboRestaurante.append(combo)
                self.fetchEmpezarBusqueda(arrayResultado: arrayComboRestaurante)
                print("Hay \(arrayComboRestaurante.count) restaurantes con categoria por buscar")
                
            })
            
        }
        
    }
    
    func fetchEmpezarBusqueda(arrayResultado:[searchResults]){
        
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
                    
                    DispatchQueue.main.async {
                        imageFondoCategoria = UIImage(data: data!)
                        
                        let datosCategoria = cellCategoriasDatos(imagenCategoriaFondo: imageFondoCategoria!, nombreCategoria: nombreCategoria)
                        
                        self.categoriasMostrar.append(datosCategoria)
                        print("Hay \(self.categoriasMostrar.count) categorias")
                        
                        self.collectionViewCategorias.reloadData()
                    }
                }
                
                
            })
            
        }
        
    }
    

    //MARK: - Funciones Para Buscar y filtrar
    func filteredContentSearchBar(_ searchText:String, scope:String = "All"){
        
        filteredRestaurantes = restaurantesResultados.filter({ (res:searchResults) -> Bool in
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
    
    @IBAction func prepareRegresarBuscar (segue:UIStoryboardSegue){
        
    }
    

}


extension BuscarRestauranteVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriasMostrar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoriaChingona = categoriasMostrar[indexPath.row]
        
        if categoriasMostrar.count > 0{
            
            UIView.animate(withDuration: 1, delay: 0, options: .transitionCurlUp, animations: {
                self.viewCargando.alpha = 0
            }, completion: nil)
            
        }
        
        let cell = collectionViewCategorias.dequeueReusableCell(withReuseIdentifier: "cellCategoria", for: indexPath) as! CategoriasCVCell
        
        cell.setCell(categoria: categoriaChingona)
        
        SVProgressHUD.dismiss()
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        indexPasar = indexPath
        
        Database.database().reference().child("restaurantes").child("categorias").removeAllObservers()
        
        performSegue(withIdentifier: "segueCategorias-Restaurantes", sender: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}


extension BuscarRestauranteVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
    
}



extension BuscarRestauranteVC : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentSearchBar(searchController.searchBar.text!)
    }
}



extension BuscarRestauranteVC : UITableViewDelegate, UITableViewDataSource{
    
    
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
        
        let searchRes:searchResults
        
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
        
        /*let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)*/
        
        performSegue(withIdentifier: "segueQuickMenu-Menu", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
}














