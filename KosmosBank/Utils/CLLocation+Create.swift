//
//  CLLocation+Create.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 18.08.17.
//
//

import CoreLocation

extension CLLocation {
    
    convenience init(_ location: Location) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
    
}
