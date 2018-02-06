//
//  SeccionSeleccionadaVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 05/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SeccionSeleccionadaVC: UIViewController {

    
    @IBOutlet weak var tableViewSeccionSeleccionada: UITableView!
    @IBOutlet weak var viewEmpty: UIView!
    
    var seccionSeleccionada:String?
    var restauranteSeleccionado:String?
    
    var datosSeccion = DatosSeccion()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if datosSeccion.arrayCellData.count == 0 {
            
            viewEmpty.isHidden = false
            
        }
        
        configNavBar()
        
        datosSeccion.arrayCellData.removeAll() //Ojo aqui
        
        queryDatosSeccionSeleccionada()
        
    }
    
    func queryDatosSeccionSeleccionada() {
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("menu").child(seccionSeleccionada!).observe(.childAdded) { (snapshot) in
            
            SVProgressHUD.show()
            
            let seccionSeleccionada2 = [snapshot.key]
            print("\(seccionSeleccionada2) en queryDatosSeccionSeleccionada")
            
            for key in seccionSeleccionada2 {
                
                print(seccionSeleccionada2, "En descargar Imagenes")
                
                let referenceImage = Storage.storage().reference().child("\(self.restauranteSeleccionado!)/menu/\(self.seccionSeleccionada!)/\(key)/\(key).jpg")
                
                referenceImage.getData(maxSize: 1 * 2048 * 2048, completion: { (data, error) in
                    
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
                        
                        self.tableViewSeccionSeleccionada.reloadData()
                        
                        
                    }
                    
                })
                
            }
            
        }
        
        Database.database().reference().child("restaurantes").child(restauranteSeleccionado!).child("menu").child(seccionSeleccionada!).removeAllObservers()
        
    }
    
    
    func configNavBar() {
        
        navigationItem.title = seccionSeleccionada
        
        
    }


}


extension SeccionSeleccionadaVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosSeccion.arrayCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let seccionSeleccionadaChingona = datosSeccion.arrayCellData[indexPath.row]
        
        let cell = tableViewSeccionSeleccionada.dequeueReusableCell(withIdentifier: "cellSeccionSeleccionada") as! SeccionSeleccionadaTVCell
        
        cell.setSeccion(seccion: seccionSeleccionadaChingona)
        
        SVProgressHUD.dismiss()
        
        if datosSeccion.arrayCellData.count > 0 {
            
            UIView.animate(withDuration: 1.3, animations: {
                self.viewEmpty.alpha = 0
            })
            
        }
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 325
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "segueSeccionSeleccionada-PlatilloSeleccionado", sender: nil)
        tableViewSeccionSeleccionada.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PlatilloSeleccionadoTVC {
            destination.platilloSeleccionado = datosSeccion.arrayCellData[(tableViewSeccionSeleccionada.indexPathForSelectedRow?.row)!].textoSeccion
            destination.restauranteSeleccionado = restauranteSeleccionado
            destination.seccionSeleccionada = seccionSeleccionada
            
        }
    }
    
    
    
    
}



























