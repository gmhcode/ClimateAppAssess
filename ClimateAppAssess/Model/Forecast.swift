//
//  Forecast.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import Foundation

///5 day forecast
struct ForecastWeather : Codable {
    let list : [List]
}
// List of Weather classes for each of the next 5 days
struct List : Codable {
        let dt : Double
        let main : Main
        let weather : [Weather]
}
