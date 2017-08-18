//
//  DownloadSession.swift
//  KosmosBank
//
//  Created by Sergey V. Krupov on 17/08/2017.
//
//

import Foundation
import RxSwift

protocol IDownloadSession {
    
    func download(_ url: URL) -> Observable<Data>
    
}

extension URLSession: IDownloadSession {
    
    func download(_ url: URL) -> Observable<Data> {
        
        return Observable.create { observer -> Disposable in
            let task = self.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                guard let nonNilData = data else {
                    observer.onError(Errors.invalidResponse)
                    return
                }
                
                observer.onNext(nonNilData)
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
}
