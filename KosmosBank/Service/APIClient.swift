//
//  APIClient.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import RxSwift
import ObjectMapper

protocol IAPIClient {
    
    func obtainBranchOffices() -> Observable<Array<BranchOffice>>
    
}

class APIClient: IAPIClient {
    
    //MARK: - Dependencies
    
    var cache: ICache?
    var downloadSession: IDownloadSession!
    var endpoint: URL!
    
    func obtainBranchOffices() -> Observable<Array<BranchOffice>> {
        
        let key = "BranchOffices"
        
        let cached: Observable<Data>
        if let cache = cache {
            cached = cache.obtainCachedObject(forKey: key)
            .flatMap { object -> Observable<Data> in
                guard let data = object as? NSData else { return Observable.empty() }
                return Observable.just(data as Data)
            }
        }
        else {
            cached = Observable.empty()
        }
        
        let download = downloadSession.download(endpoint).do(onNext: { [weak self] data in
            guard let this = self else { return }
            this.cache?.cacheObject(data as NSData, forKey: key)
        })
        
        return Observable.concat([cached, download])
            .take(1)
            .flatMap { data -> Observable<Array<BranchOffice>> in
                if let string = String(data: data, encoding: .utf8) {
                    if let result = try? Mapper<ResponseModel>().map(JSONString: string) {
                        return Observable.just(result.items)
                    }
                }
                return Observable.error(Errors.invalidData)
            }
    }
}
