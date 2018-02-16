//
//  UnirteAQuickMenuPageVC.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 15/02/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit

class UnirteAQuickMenuPageVC: UIPageViewController {

    lazy var viewControllerList:[UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let Pagina1 = sb.instantiateViewController(withIdentifier: "Pagina1")
        let Pagina2 = sb.instantiateViewController(withIdentifier: "Pagina2")
        let Pagina3 = sb.instantiateViewController(withIdentifier: "Pagina3")
        
        return [Pagina1, Pagina2, Pagina3]
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.dataSource = self
        
        if let firstVC = viewControllerList.first {
            
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
            
        }
        
    }

    


}

extension UnirteAQuickMenuPageVC: UIPageViewControllerDataSource {
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let VCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let previousIndex = VCIndex - 1
        
        guard previousIndex >= 0 else {return nil}
        
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let VCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        let nextIndex = VCIndex + 1
        
        guard viewControllerList.count != nextIndex else {return nil}
        
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
        
    }
    
    
    
    
}





















