//
//  Location.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import ObjectMapper

struct Location: ImmutableMappable {
    
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(map: Map) throws {
        latitude  = try map.value(Key.lat.rawValue)
        longitude = try map.value(Key.lng.rawValue)
    }
    
    mutating func mapping(map: Map) {
        latitude  >>> map[Key.lat.rawValue]
        longitude >>> map[Key.lng.rawValue]
    }

    //MARK: - Private
    private enum Key: String {
        case lat
        case lng
    }
    
}

extension Location: Equatable {
    
    public static func ==(lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude
    }
    
}
