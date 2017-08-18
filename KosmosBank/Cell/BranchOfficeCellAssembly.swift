//
//  BranchOfficeCellAssembly.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 18.08.17.
//
//

import EasyDi

class BranchOfficeCellAssembly: Assembly {
    
    lazy var serviceAssembly: ServiceAssembly = self.context.assembly()
    
    func inject(into branchOfficeCell: BranchOfficeCell) {
        defineInjection(into: branchOfficeCell) {
            $0.locationService = self.serviceAssembly.locationService
        }
    }
    
}
