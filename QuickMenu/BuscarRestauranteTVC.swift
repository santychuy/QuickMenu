//
//  BuscarRestauranteVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 14/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD


class BuscarRestauranteTVC: UITableViewController, GADBannerViewDelegate{

    
    @IBOutlet weak var collectionViewVistoRecientes: UICollectionView!
    @IBOutlet weak var collectionViewCategorias: UICollectionView!
    @IBOutlet var viewCargando: UIView!
    @IBOutlet weak var viewADPrincipio: GADBannerView!
    
    var categoriasMostrar = [cellCategoriasDatos]()
    
    var indexPasar:IndexPath?
    
    let review = storeKitFunc()
    let hayInternet = checarInternetFunc()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarAd()
        collectionViewCategorias.delegate = self
        collectionViewCategorias.dataSource = self
        
        fetchCategorias()
        
        //review.showReview()  //Quitarlo despues
        
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
        configSearchBar()
        
    }
    
    func configSearchBar(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Buscar Restaurante"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Medium", size: 21)!,
                                                                        NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.font:UIFont.init(name: "Avenir-Heavy", size: 36)!,
                                                                        NSAttributedStringKey.foregroundColor:UIColor.white]
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.isTranslucent = true
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? Prueba2VC{
            destination.recibirCategoria = categoriasMostrar[(indexPasar?.row)!].nombreCategoria
        }
        
    }
    
    
    func fetchVistoRecientes(){
        
        
        
    }
    
    
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
    


}


extension BuscarRestauranteTVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriasMostrar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categoriaChingona = categoriasMostrar[indexPath.row]
        
        let cell = collectionViewCategorias.dequeueReusableCell(withReuseIdentifier: "cellCategoria", for: indexPath) as! CategoriasCVCell
        
        cell.setCell(categoria: categoriaChingona)
        
        SVProgressHUD.dismiss()
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionViewCategorias.cellForItem(at: indexPath)
        cell?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cell?.layer.borderWidth = 1
        
        indexPasar = indexPath
    
        Database.database().reference().child("restaurantes").child("categorias").removeAllObservers()
        
        performSegue(withIdentifier: "segueCategorias-Restaurantes", sender: nil)
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    
}





















