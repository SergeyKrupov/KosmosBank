//
//  Cache.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 18.08.17.
//
//

import Foundation
import RxSwift

protocol ICache {

    func obtainCachedObject(forKey key: String) -> Observable<AnyObject>
    
    func cacheObject(_ object: AnyObject, forKey key: String)
    
}

class Cache: ICache {
    
    //MARK: - Public
    
    let objectsTTL: TimeInterval = 30
    
    init() {
        _cache = NSCache()
        _cache.countLimit = 1
    }
    
    func obtainCachedObject(forKey key: String) -> Observable<AnyObject> {
        return Observable.deferred { [weak self] () -> Observable<AnyObject> in
            guard let this = self else { return Observable.empty() }
            if let entry = this._cache.object(forKey: key as NSString) as? CacheEntry {
                if entry.validTo.timeIntervalSinceNow >= 0 {
                    return Observable.just(entry.object, scheduler: MainScheduler.asyncInstance)
                }
                else {
                    this._cache.removeObject(forKey: key as NSString)
                }
            }
            return Observable.empty()
        }
        .subscribeOn(_scheduler)
    }
    
    func cacheObject(_ object: AnyObject, forKey key: String) {
        let _ = _scheduler.schedule(0) { [weak self] _ in
            if let this = self {
                let entry = CacheEntry(object, validToDate: Date(timeIntervalSinceNow: this.objectsTTL))
                this._cache.setObject(entry, forKey: key as NSString)
            }
            return Disposables.create()
        }
    }
    
    //MARK: - Private
    
    class CacheEntry {
        var validTo: Date
        var object: AnyObject
        
        init(_ object: AnyObject, validToDate date: Date) {
            self.object = object
            self.validTo = date
        }
    }
    
    let _scheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "Cache scheduler")
    let _cache: NSCache<NSString, AnyObject>
    
}
