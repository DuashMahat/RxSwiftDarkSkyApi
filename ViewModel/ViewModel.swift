//
//  ViewModel.swift
//  JSONDATA
//
//  Created by Duale on 3/27/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SwiftyJSON


class ViewModel {
    let datumRelay : BehaviorRelay<[DailyDatum]> = BehaviorRelay(value: [])
    let dailyRelay : BehaviorRelay<[Daily]> = BehaviorRelay(value: [])
    var dailyArray = [Daily]()
    var dailyDatum = [DailyDatum]()
    var error : Error?
    var disposeBag = DisposeBag()
    func callAPI(request: URLRequest){
        let disposable = APIHandler().getData(request: request).subscribe(onNext: { (data) in
            do{
//              let model = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                guard let model = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary else {return}
//                print(model)
                let dailyweather = model["daily"] as! [String : Any]
                let days = dailyweather["data"] as! [[String: Any]]
                let mainsummary = dailyweather["summary"] as! String
                let icon = dailyweather["icon"] as! String
                let timezone = model["timezone"] as! String
                let hourly = model["hourly"] as! [String : Any]
                let currently = model["currently"] as! [String : Any]
                let currentweather = currently["temperature"] as! Double
                let currentsummary = currently["summary"] as! String
//                let currentMa
                var dailyArray = [Daily]()
                var dailyDatum = [DailyDatum]()
                for item in days {
                    let maxtemp = item["temperatureHigh"] as! Double
                    let mintemp = item["temperatureLow"] as! Double
                    let summary = item["summary"] as! String
                    let icon =    item["icon"] as! String
                    dailyDatum.append( DailyDatum.init(temperatureLow: mintemp, temperatureHigh: maxtemp, summary: summary, icon: icon, timezone: timezone , weeklysummary: mainsummary , currentweather: currentweather , currentsummary: currentsummary ))
                }
                dailyArray.append(Daily(summary: mainsummary, data: dailyDatum))
                dailyDatum.remove(at: 0)
                dailyDatum.remove(at: 1)
                self.dailyRelay.accept(dailyArray)
                self.dailyArray  = dailyArray
                self.datumRelay.accept(dailyDatum)
                self.dailyDatum = dailyDatum
            } catch {
                print("===erroR===")
                self.error = error
                print(error)
                print("===erroR===")
            }
        }, onError: { (error) in
            self.error = error
        }, onCompleted: {

        }) {
            print(self.dailyDatum)
        }
        disposable.disposed(by: disposeBag)
    }
}





///*
//   struct Daily: Codable {
//       let summary: String
//       let data: [DailyDatum]
//   }
//
//   // MARK: - DailyDatum
//   struct DailyDatum: Codable {
//       let temperatureLow : Double?
//       let temperatureHigh: Double?
//       let summary, icon: String?
//
//   }
// */
