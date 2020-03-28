//
//  Model.swift
//  WeatherData
//
//  Created by Duale on 3/25/20.
//  Copyright © 2020 Duale. All rights reserved.
//

import Foundation

struct Model  {
    var timezone : String
    var summary : String
    var temperatureHigh : Double
    var temperatureLow : Double
    var currenttemperature : Double
    var hourlysummary : String
    var dailysummary : String
}

class Dailies {
    var daily : Daily
    init(daily : Daily) {
        self.daily = daily
    }
    
}

// MARK: - Daily
struct Daily: Codable {
    let summary: String
    let data: [DailyDatum]
}

// MARK: - DailyDatum
struct DailyDatum: Codable {
    let temperatureLow : Double
    let temperatureHigh: Double
    let summary : String
    let icon : String
    let timezone : String
    let weeklysummary : String
    var currentweather : Double
    var currentsummary : String 
}

struct SummaryTimezoneCurrent {
    var timezone : String
    let summary : String
    var currentweather : String
    var maxWeather : String
    var minWeather : String
    
}




