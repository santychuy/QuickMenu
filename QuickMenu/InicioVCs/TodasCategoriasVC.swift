//
//  TodasCategoriasVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/04/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TodasCategoriasVC: UIViewController {

    @IBOutlet weak var collectionViewTodasCategorias: UICollectionView!
    @IBOutlet weak var viewCargando: UIView!
    
    var categoriasMostrar = [cellCategoriasDatos]()
    
    var indexPasar:IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if categoriasMostrar.count == 0{
            
            self.viewCargando.isHidden = false
            
        }
        
        configCollectionView()
        fetchCategorias()
        configNavBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func configCollectionView(){
        collectionViewTodasCategorias.delegate = self
        collectionViewTodasCategorias.dataSource = self
    }
    
    func configNavBar(){
        navigationItem.title = "Categorias"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        } else {
            // Fallback on earlier versions
        }
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
                    
                    if self.categoriasMostrar.count <= 6{
                        DispatchQueue.main.async {
                            imageFondoCategoria = UIImage(data: data!)
                            
                            let datosCategoria = cellCategoriasDatos(imagenCategoriaFondo: imageFondoCategoria!, nombreCategoria: nombreCategoria)
                            
                            self.categoriasMostrar.append(datosCategoria)
                            print("Hay \(self.categoriasMostrar.count) categorias")
                            
                            self.collectionViewTodasCategorias.reloadData()
                        }
                    }else{
                        print("Son más de un elemento, ya no más")
                    }
                    
                    
                }
                
                
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? Prueba2VC{
            destination.recibirCategoria = categoriasMostrar[(indexPasar?.row)!].nombreCategoria
        }
        
    }
    
    

}


extension TodasCategoriasVC: UICollectionViewDelegate, UICollectionViewDataSource{
    
    
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
        
        let cell = collectionViewTodasCategorias.dequeueReusableCell(withReuseIdentifier: "cellCategoriaTodas", for: indexPath) as! TodasCategoriasCVCell
        
        cell.setCell(categoria: categoriaChingona)
        
        SVProgressHUD.dismiss()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("Entro en true")
        indexPasar = indexPath
        
        Database.database().reference().child("restaurantes").child("categorias").removeAllObservers()
        
        performSegue(withIdentifier: "segueTodasCategorias-Restaurantes", sender: nil) //Ojo
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    
}






























