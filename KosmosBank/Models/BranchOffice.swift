//
//  BranchOffice.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import ObjectMapper

struct BranchOffice: ImmutableMappable {
    
    let title: String
    let address: String
    let workingHours: String
    let location: Location
    
    
    init(map: Map) throws {
        title        = try map.value(Key.title.rawValue)
        address      = try map.value(Key.address.rawValue)
        workingHours = try map.value(Key.workingHours.rawValue)
        location     = try map.value(Key.location.rawValue)
    }
    
    mutating func mapping(map: Map) {
        title        >>> map[Key.title.rawValue]
        address      >>> map[Key.address.rawValue]
        workingHours >>> map[Key.workingHours.rawValue]
        location     >>> map[Key.location.rawValue]
    }
    
    //MARK: - Private
    
    private enum Key: String {
        case title
        case address
        case workingHours = "schedule"
        case location
    }
    
}
