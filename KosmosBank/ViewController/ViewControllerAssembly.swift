//
//  ViewControllerAssembly.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import EasyDi

class ViewControllerAssembly: Assembly {

    lazy var serviceAssembly: ServiceAssembly = self.context.assembly()
    
    func inject(into feedViewController: ViewController) {
        defineInjection(into: feedViewController) {
            $0.apiClient = self.serviceAssembly.apiClient
        }
    }
    
}
