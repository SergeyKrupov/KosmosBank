//
//  ResponseModel.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import ObjectMapper

struct ResponseModel: ImmutableMappable {
    
    let items: [BranchOffice]
    
    init(map: Map) throws {
        items = try map.value(Key.items.rawValue)
    }
    
    func mapping(map: Map) {
        items >>> map[Key.items.rawValue]
    }
    
    //MARK: - Private
    
    private enum Key: String {
        case items
    }
    
}
