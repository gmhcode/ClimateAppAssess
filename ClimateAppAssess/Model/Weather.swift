//
//  Weather.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//


import Foundation
/// Single Day Weather
struct WeatherData : Codable {
    ///The name of the city
    let name : String
    ///Date / Time
    let dt : Double
    let main : Main
    let weather: [Weather]
}
/// Single Day Weather Data
struct Main: Codable {
    let temp : Double
}

struct Weather: Codable {
    // Describes the weather (cloudy, clear sky, etc...)
    let description : String
    let id : Int
    let icon : String
}



