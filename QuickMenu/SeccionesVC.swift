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
     
        
    }

    
    //MARK: - Config. NavBar
    
    func configNavBar() {
        
        navigationItem.title = "Secciones"
        
        
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
            
            UIView.animate(withDuration: 1.3, animations: {
                self.viewTVCVacio.alpha = 0
            })
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
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























