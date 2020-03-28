//
//  WeatherViewController.swift
//  WeatherData
//
//  Created by Duale on 3/25/20.
//  Copyright © 2020 Duale. All rights reserved.
//  THIS PROJECT IS FREE TO BE USED EITHER AS A REFERENCE O
//

import UIKit
import Foundation
import RxAlamofire
import CoreLocation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON
class WeatherViewController: UIViewController  , CLLocationManagerDelegate, UITableViewDelegate {
    @IBOutlet weak var desclabel: UILabel!
    let disposebag = DisposeBag()
    var currentDay : String = ""
    var  urlString : String = "https://api.darksky.net/forecast/"
    var key : String = "2e587e8ea711a705a25b18a06ab4437a"
    var WEATHER_URL : String = ""
    var arrayDays  = ["Friday" , "Saturday" , "Sunday" , "Monday", "Tuesday", "Wednesday", "Thursday"]
    var arrayDaysWithoutToday = [String]()
    var dic =  [String : [String]]()
    var arraynextdays  = [[String]]()
    @IBOutlet weak var tableview: UITableView!
    let  locationManager =  CLLocationManager()
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var currentdaylabel: UILabel!
    @IBOutlet weak var tempreturehighlabel: UILabel!
    @IBOutlet weak var tempreturelowlabel: UILabel!
    @IBOutlet weak var currTemp: UILabel!
    var weatherData = [Model]()
    var viewModel = ViewModel()
    var dailywet = [DailyDatum]()
    var timezone : String = ""
    var weeklysummary : String = ""
    var dailysummary : String = ""
    var currentweather : String = ""
    var currentMin : String = ""
    var currentMax : String = ""
    var currentTemP : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate  = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        centerAlignTextsInTextLabels()
//        self.tableview.delegate = self
//        self.tableview.dataSource = self
        tableview.backgroundColor = UIColor.clear
        self.getCurrentDay()
        print(currentDay)
        currentdaylabel.text = currentDay + " today"
        getArrayNoToday()
        dic.removeValue(forKey: "")
        tableview.reloadData()
        self.navbarcustom()
        borderLayout()
        setUpSubscription()
        setUpViewBindings()
       
    }
    
    
    
    
    func dictest () {
        print(dic)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
    }

    func getCurrentDay()->String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        currentDay = dayInWeek
        return currentDay
    }
    
}


extension WeatherViewController {
    func centerAlignTextsInTextLabels() {
        locationlabel.adjustsFontSizeToFitWidth  = true
        descriptionlabel.adjustsFontSizeToFitWidth = true
        currentdaylabel.adjustsFontSizeToFitWidth = true
        locationlabel.textAlignment = .center
        descriptionlabel.textAlignment = .center
        currentdaylabel.textAlignment = .center
        currTemp.textAlignment = .center
        tempreturelowlabel.textAlignment = .center
        tempreturehighlabel.textAlignment = .center
        desclabel.textAlignment = .center
        desclabel.adjustsFontSizeToFitWidth = true
        currTemp.adjustsFontSizeToFitWidth = true
    
    }
    
    
}

//extension WeatherViewController : UITableViewDelegate , UITableViewDataSource  {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("=============|||||||||||||||\(weatherData.count)")
////        return arrayDaysWithoutToday.count
//        return weatherData.count
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("+++++++++++++++++++++++ \(weatherData.count)        \(arrayDaysWithoutToday.count)" )
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTableViewCell
//        cell.backgroundColor = UIColor.clear
//        let mxt = String(Int(weatherData[indexPath.row].temperatureHigh)) + "°"
//        let mint = String(Int(weatherData[indexPath.row].temperatureLow)) + "°"
//        cell.updateCell(day: arrayDaysWithoutToday[indexPath.row], maxt: mxt , mint: mint)
//        if weatherData[indexPath.row].dailysummary.lowercased().contains("rain") {
//            cell.updateCellImage(image: UIImage(named: "rain")!)
//        } else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("clear") ) {
//             cell.updateCellImage(image: UIImage(named: "day_clear")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("cloud") ) {
//             cell.updateCellImage(image: UIImage(named: "cloudy")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("fog") ) {
//             cell.updateCellImage(image: UIImage(named: "fog")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("mixt") ) {
//             cell.updateCellImage(image: UIImage(named: "mist")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("snow") ) {
//             cell.updateCellImage(image: UIImage(named: "snow")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("clear") ) {
//             cell.updateCellImage(image: UIImage(named: "day_clear")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("day rain") ) {
//             cell.updateCellImage(image: UIImage(named: "day_rain")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("rain thunder")) {
//             cell.updateCellImage(image: UIImage(named: "rain_thunder")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("full moon")) {
//                    cell.updateCellImage(image: UIImage(named: "night_full_moon_clear")!)
//        } else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("thunder")) {
//                    cell.updateCellImage(image: UIImage(named: "thunder")!)
//        }else if ( weatherData[indexPath.row].dailysummary.lowercased().contains("wind")) {
//                    cell.updateCellImage(image: UIImage(named: "wind")!)
//        }
//        else {
//            cell.updateCellImage(image: UIImage(named: "day_clear")!)
//        }
//        return cell
//    }
//
//
//}



extension WeatherViewController  {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if (location.horizontalAccuracy > 0 )  {
                  locationManager.stopUpdatingLocation()
                  locationManager.delegate = nil   // for printing/updating the location ones
                  print("longitude =  \(location.coordinate.longitude)  , latitude = \(location.coordinate.latitude)")
                  // let us set some parameters where we need to send to openweathermaps.org
                  let latitude = String(location.coordinate.latitude)
                  let longitude = String(location.coordinate.longitude)
                  print(latitude)
                  print(latitude)
                  WEATHER_URL = urlString  +  key +  "/" + latitude + "," +  longitude
                  print(WEATHER_URL)
                  setUpSubscription()
              }
       }
    
    

       func setUpSubscription() {
//          print(WEATHER_URL)
         callAPI(withUrlString: WEATHER_URL)
        
       }
        
       public func callAPI(withUrlString : String) {
        let url = withUrlString
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
        request.httpMethod = "GET"
        self.viewModel.callAPI(request: request as URLRequest )
       }
    
}


extension WeatherViewController  {
   func setUpViewBindings() {
           viewModel.datumRelay.bind(to: self.tableview.rx.items) { (tableView, row, element) in
              print("===========daildaum")
              self.timezone = element.timezone
              self.dailysummary = element.currentsummary
              self.weeklysummary = element.weeklysummary
              let cmax = self.farheinetToCelcius(far: element.temperatureHigh)
              let cmin = self.farheinetToCelcius(far: element.temperatureLow)
              let ct = self.farheinetToCelcius(far: element.currentweather)
              self.currentMax = String(Int(cmax))
              self.currentMin = String(Int(cmin))
               self.currentTemP = String(Int(ct))
            self.upateUILabels(location: self.timezone, desc: self.dailysummary, currMin: self.currentMin, currMax: self.currentMax, weeklysum: self.weeklysummary , currtemp: self.currentTemP)
              print(element)
              print("===========daildaum")
              let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CellTableViewCell
              cell.backgroundColor = UIColor.clear
              let mxt = self.farheinetToCelcius(far: element.temperatureHigh)
              let min = self.farheinetToCelcius(far: element.temperatureLow)
            cell.updateCell(day: self.arrayDaysWithoutToday[row], maxt: String(Int(mxt)) + "°", mint: String(Int(min)) + "°")
               if element.summary.lowercased().contains("rain") {
                          cell.updateCellImage(image: UIImage(named: "rain")!)
                      } else if (element.summary.lowercased().contains("clear") ) {
                           cell.updateCellImage(image: UIImage(named: "day_clear")!)
                      }else if ( element.summary.lowercased().contains("cloud") ) {
                           cell.updateCellImage(image: UIImage(named: "cloudy")!)
                      }else if ( element.summary.lowercased().contains("fog") ) {
                           cell.updateCellImage(image: UIImage(named: "fog")!)
                      }else if ( element.summary.lowercased().contains("mixt") ) {
                           cell.updateCellImage(image: UIImage(named: "mist")!)
                      }else if (element.summary.lowercased().contains("snow") ) {
                           cell.updateCellImage(image: UIImage(named: "snow")!)
                      }else if (element.summary.lowercased().contains("clear") ) {
                           cell.updateCellImage(image: UIImage(named: "day_clear")!)
                      }else if (element.summary.lowercased().contains("day rain") ) {
                           cell.updateCellImage(image: UIImage(named: "day_rain")!)
                      }else if (element.summary.lowercased().contains("rain thunder")) {
                           cell.updateCellImage(image: UIImage(named: "rain_thunder")!)
                      }else if (element.summary.lowercased().contains("full moon")) {
                                  cell.updateCellImage(image: UIImage(named: "night_full_moon_clear")!)
                      } else if (element.summary.lowercased().contains("thunder")) {
                                  cell.updateCellImage(image: UIImage(named: "thunder")!)
                      }else if ( element.summary.lowercased().contains("wind")) {
                          cell.updateCellImage(image: UIImage(named: "wind")!)
                      }
                      else {
                          cell.updateCellImage(image: UIImage(named: "day_clear")!)
                      }
              return cell
           }
           .disposed(by: self.disposebag)
      }
}


extension WeatherViewController {
    func printDW () {
       print("daily===============wet")
       print(dailywet)
    }
}

//extension  WeatherViewController  {
//    func getweatherTwo(url: String) {
//        Alamofire.request(url).responseJSON { response in
//            if response.result.isSuccess {
//                let json : JSON = JSON(response.result.value!)
//                print(json)
//            } else {
//              print("Error")
//            }
//        }
//    }
//}
//
//
//
//
//
//
//
//extension WeatherViewController  {
//    func getWeatherData (url: String ) {
//      RxAlamofire.requestJSON(.get, url).subscribe(onNext: { (r, json) in
//        guard let jsonreturned = json as? NSDictionary else {return}
//        guard let jsonFinal = jsonreturned as? NSDictionary else {return}
////        print(jsonFinal)
//        let timezone = jsonFinal["timezone"] as! String
//        let daily = jsonFinal["daily"] as! [String : Any]
//        let weeklysummary = daily["summary"] as! String
//        let currently = jsonFinal["currently"] as! [String : Any]
//        let currentTemp = self.farheinetToCelcius(far: currently["temperature"] as! Double)
//        let days = daily["data"] as! [[String: Any]]
//        let hourly = jsonFinal["hourly"] as! [String : Any]
//        let hourlydescription = hourly["summary"] as! String
//        for day in days {
//            let tmax = self.farheinetToCelcius(far: day["temperatureMax"] as! Double)
//            let tmin = self.farheinetToCelcius(far: day["temperatureMax"] as! Double)
//            let dailysummary = day["summary"] as! String
//            self.weatherData.append(Model(timezone: timezone, summary: weeklysummary, temperatureHigh: tmax, temperatureLow: tmin, currenttemperature: currentTemp , hourlysummary: hourlydescription , dailysummary: dailysummary))
//           }
//             }, onError: { (error) in
//                 print(error)
//                 return
//             }, onCompleted: {
//                self.weatherData.remove(at: 0)
//                self.weatherData.remove(at: 1)
//                self.updateWeather(weatherData: self.weatherData)
//                self.tableview.reloadData()
//
//             }) {
//             }.disposed(by: disposebag)
//    }
//}
//extension WeatherViewController  {
//    func updateWeather (weatherData:  [Model] ) {
//        print(weatherData   )
//        descriptionlabel.text = weatherData[0].hourlysummary
//        locationlabel.text = splitString(str: weatherData[0].timezone)
//        currTemp.text = String(Int(weatherData[0].currenttemperature)) + "°"
//        tempreturehighlabel.text = String(Int(weatherData[0].temperatureHigh)) + "°"
//        tempreturehighlabel.text = String(Int(weatherData[0].temperatureLow)) + "°"
//        currentdaylabel.text = currentDay +  " today"
//        desclabel.text = weatherData[0].summary
//        print("===================   \(weatherData.count)")
//    }
//}



extension WeatherViewController  {
    func getArrayNoToday() -> [String] {
        switch currentDay {
        case "Monday":
            arrayDaysWithoutToday = ["Tuesday", "Wednesday", "Thursday" ,"Friday" , "Saturday" , "Sunday"]
        case "Tuseday":
            arrayDaysWithoutToday = ["Wednesday", "Thursday" ,"Friday" , "Saturday" , "Sunday" , "Monday"]
        case "Wednesday":
            arrayDaysWithoutToday = ["Thursday" ,"Friday" , "Saturday" , "Sunday" , "Monday", "Tuesday"]
        case "Thursday":
            arrayDaysWithoutToday = [ "Friday" , "Saturday" , "Sunday" , "Monday", "Tuesday" , "Wednesday"]
        case "Friday":
              arrayDaysWithoutToday = [ "Saturday" , "Sunday" , "Monday", "Tuesday" , "Wednesday", "Thurday"]
        case "Saturday":
              arrayDaysWithoutToday = [ "Sunday" , "Monday", "Tuesday" , "Wednesday", "Thurday" , "Friday" ]
        case "Sunday":
              arrayDaysWithoutToday = [ "Monday", "Tuesday" , "Wednesday", "Thurday" , "Friday" , "Saturday"]
        
        default:
              arrayDaysWithoutToday = [ "Sunday" , "Monday", "Tuesday" , "Wednesday", "Thurday" , "Friday" , "Saturday"]
        }
        return arrayDaysWithoutToday
    }
}

extension WeatherViewController  {
    func updateLabels( location: String , currentweather : String , currentMin: String , currentMax : String ) {
      
    }
}

extension WeatherViewController   {
    func splitString(str: String)-> String {
        let array = str.components(separatedBy: "/")
        return array[1]
    }
}

extension WeatherViewController  {
    func farheinetToCelcius( far : Double) -> Double {
       return (far - 32) *  5/9
    }
}

extension WeatherViewController  {
    func navbarcustom () {
      if #available(iOS 11.0, *) {
             UINavigationBar.appearance().prefersLargeTitles = true
             UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
         } else {
             UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
         }
    }
}

extension WeatherViewController {
    func borderLayout() {
        desclabel.layer.borderColor = UIColor.white.cgColor
        desclabel.layer.borderWidth = 1.0
        locationlabel.layer.borderColor = UIColor.white.cgColor
        locationlabel.layer.borderWidth = 0.5
        currentdaylabel.layer.borderColor = UIColor.white.cgColor
        currentdaylabel.layer.borderWidth = 0.2
    
    }
}

extension WeatherViewController {
    func upateUILabels (location: String , desc: String , currMin : String , currMax: String , weeklysum : String  , currtemp: String ) {
        let timezone_splitted = splitString(str: location)
        locationlabel.text = timezone_splitted
        desclabel.text = weeklysum
        descriptionlabel.text = desc
        currTemp.text = currtemp + "°"
        tempreturehighlabel.text = currMax + "°"
        tempreturelowlabel.text = currMin + "°"
        
    }
}





