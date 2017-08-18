//
//  ServiceAssembly.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import EasyDi

class ServiceAssembly: Assembly {
    
    var apiClient: IAPIClient {
        return define(scope: .lazySingleton, init: APIClient()) {
            $0.downloadSession = self.session
            $0.endpoint = self.endpoint
            $0.cache = self.cache
        }
    }
    
    var locationService: ILocationService {
        return define(scope: .lazySingleton, init: LocationService())
    }
    
    var session: IDownloadSession {
        return define(scope: .lazySingleton, init: URLSession(configuration: self.sessionConfiguration))
    }
    
    var cache: ICache {
        return define(init: Cache())
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        return define(scope: .lazySingleton, init: URLSessionConfiguration.default)
    }
    
    var endpoint: URL {
        return define(init: URL(string: "http://gymn652.ru/tmp/unicorn.txt-2.json")!)
    }
    
}
