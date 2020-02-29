//
//  WeatherController.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import CoreLocation
import UIKit
class WeatherController {
    
    
    static let shared = WeatherController()
    
    private let currentWeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f3de58f44102809871379c2d37a64aa3&units=Imperial"
    
    private let forecastWeatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid=f3de58f44102809871379c2d37a64aa3&units=Imperial"
    
    private let iconUrl = "https://openweathermap.org/img/wn/"
    
    ///Holds all the icons, will start deleting icons if there are too many
    let imageCache = NSCache<NSString, UIImage>()
    var forecast : ForecastWeather?
    var currentWeather : WeatherData?
    
    // MARK: - FetchWeather
    func fetchWeather(long: CLLocationDegrees, lat: CLLocationDegrees, completion: @escaping(WeatherData?) -> Void) {
        let urlString = "\(currentWeatherURL)&lat=\(lat)&lon=\(long)"
        print(urlString)
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                    completion(nil)
                    return
                }
                
                
                guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<");completion(nil); return}

                
                do {
                    let jsonDecoder = JSONDecoder()
                    let weatherData = try jsonDecoder.decode(WeatherData.self, from: data)
                    self.currentWeather = weatherData
                    completion(weatherData)
                }catch let er{
                    print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                    completion(nil)
                }
            }.resume()
        }
    }
    
    // MARK: - fetch5DayWeather
    ///fetches the 5 day weather forecast
    func fetch5DayWeather(long: CLLocationDegrees, lat: CLLocationDegrees, completion: @escaping(ForecastWeather?) -> Void) {
        let urlString = "\(forecastWeatherURL)&lat=\(lat)&lon=\(long)"
        print(urlString)
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                    completion(nil)
                    return
                }
                
                
                guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<");completion(nil); return}

                
                do {
                    let jsonDecoder = JSONDecoder()
                    let forecast = try jsonDecoder.decode(ForecastWeather.self, from: data)
                    self.forecast = forecast
                   
                    completion(forecast)
                }catch let er{
                    print("❌ There was an error in \(#function) \(er) : \(er.localizedDescription) : \(#file) \(#line)")
                    completion(nil)
                }
            }.resume()
        }
    }
    // MARK: - retrieveImageFromCache
    /// checks the image cache for a image, if the image is there, it returns the image, if the image is not there, it fetches the image, populates the cache, then returns the image
    func retrieveImageFromCache(weather: Weather, completion: @escaping (UIImage)->Void) {
        
        if let cachedImage = imageCache.object(forKey: weather.icon as NSString) {
            completion(cachedImage)

        } else {
            fetchWeatherIcons(weather: weather) { (image) in
                self.imageCache.setObject(image ?? UIImage(), forKey: weather.icon as NSString)
                completion(image ?? UIImage())
            }
        }
    }
    
    // MARK: - Fetch Weather Icons
    func fetchWeatherIcons(weather: Weather, completion: @escaping (UIImage?)->Void) {
        let urlString = "\(iconUrl)\(weather.icon)@2x.png"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    print("❌ There was an error in \(#function) \(error) : \(error.localizedDescription) : \(#file) \(#line)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<");completion(nil); return}

                let image = UIImage(data: data)
                completion(image)
            }.resume()
        }
    }
}
