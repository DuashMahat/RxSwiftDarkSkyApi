//
//  APIHandler.swift
//  JSONDATA
//
//  Created by Duale on 3/27/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire

class APIHandler {
    func getData(request: URLRequest) -> Observable<Data?>{
        Observable<Data?>.create { observer in
            URLSession.shared.dataTask(with: request) { (data, response, error) in
//                observer.onNext(data)
                if error != nil {
                    observer.onError(error!)
                }
                if (error == nil ) {
                   observer.onNext(data)
                }
                observer.onCompleted()
            }.resume()
            let disposable = Disposables.create()
            return disposable
        }
        
    }
}
