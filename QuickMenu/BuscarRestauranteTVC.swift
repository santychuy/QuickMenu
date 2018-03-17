//
//  BuscarRestauranteVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 14/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SVProgressHUD

class BuscarRestauranteTVC: UITableViewController {

    
    @IBOutlet weak var collectionViewVistoRecientes: UICollectionView!
    @IBOutlet weak var collectionViewCategorias: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configNavBar()
        
    }

    
    func configNavBar(){
        
        configSearchBar()
        
    }
    
    func configSearchBar(){
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Buscar Restaurante"
        navigationItem.searchController = searchController
        
    }
    
    
    func fetchVistoRecientes(){
        
        
        
    }
    
    
    func fetchCategorias(){
        
        
        
    }
    


}


/*extension BuscarRestauranteTVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}*/





















