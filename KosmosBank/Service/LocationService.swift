//
//  LocationService.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import CoreLocation
import RxSwift

protocol ILocationService {
    
    func observeLocation() -> Observable<Location?>
    
}

class LocationService: NSObject, ILocationService {
    
    //MARK: - Public
    
    func observeLocation() -> Observable<Location?> {
        return _observable
    }
    
    //MARK: - Private
    
    fileprivate let _subject = BehaviorSubject<Location?>(value: nil)
    
    fileprivate lazy var _observable: Observable<Location?> = {
        
        let subject = self._subject
        return Observable.create { observer in
            let locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 100.0  // In meters.
            locationManager.delegate = self
            
            // Do not start services that aren't available.
            if !CLLocationManager.locationServicesEnabled() {
                // Location services is not available.
                observer.onCompleted()
                return Disposables.create()
            }
            
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .authorizedWhenInUse && authStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
            else if authStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            let d = subject.subscribe(observer)
            
            return Disposables.create {
                locationManager.stopUpdatingLocation()
                d.dispose()
            }
        }
        .multicast(BehaviorSubject<Location?>(value: nil)).refCount()
    }()
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        let location = Location(latitude: coordinate.latitude, longitude: coordinate.longitude)
        _subject.onNext(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else { return }
        manager.startUpdatingLocation()
    }
    
}
