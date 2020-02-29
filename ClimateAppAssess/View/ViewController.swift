//
//  ViewController.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//
import UIKit
import CoreLocation

class ViewController: UIViewController {

    
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!

    @IBOutlet weak var seeFiveDayButton: UIButton!
    @IBOutlet weak var iconImage: UIImageView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        setViews()
        // calling fetch weather here as well as in the didChangeAuthorization function because sometimes the didChangeAuthorization function doesnt get called when the app has been inactive for a while
        fetchAllWeather()
    }
    /// Used in the completion of fetchWeather
    func setLoadedViews(weatherData: WeatherData, image: UIImage) {
        DispatchQueue.main.async {
            
            self.cityNameLabel.text = weatherData.name
            self.tempLabel.text = String(weatherData.main.temp) + " °F"
            self.iconImage.image = image
        }
    }
    /// If a fetch function throws an error, this will present an alert asking the user to retry the fetch
    func reTryFetchAlert() {
        let alertController = UIAlertController(title: "Failed", message: "Something went wrong, try again?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.fetchAllWeather()
        }
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Fetch functions
    ///fetched the single day and 5 day forecast weather, then sets the views to represent the weather data, and unhides the 5 day forecast button
    func fetchAllWeather() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            
            guard let location = locationManager.location else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
            WeatherController.shared.fetchWeather(long: location.coordinate.longitude, lat: location.coordinate.latitude) { (weatherData) in
                
                guard let weatherData = weatherData else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
                
                WeatherController.shared.fetchWeatherIcons(weather: weatherData.weather[0]) { (image) in
                    guard let image = image else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

                    self.setLoadedViews(weatherData: weatherData, image: image)
                }
                print(weatherData.name)
            }
            
            WeatherController.shared.fetch5DayWeather(long: location.coordinate.longitude, lat: location.coordinate.latitude) { (forecast) in
                ///make the 5 day forecast button visible if the fetch is successful
                guard forecast != nil else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}

                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1) {
                        self.seeFiveDayButton.alpha = 1
                    }
                }
            }
        }
    }
    
    func setViews(){
        seeFiveDayButton.alpha = 0
        seeFiveDayButton.isSpringLoaded = true
        seeFiveDayButton.layer.cornerRadius = 10
        seeFiveDayButton.layer.borderWidth = 2
        seeFiveDayButton.layer.borderColor = #colorLiteral(red: 0.4980392157, green: 0.4980392157, blue: 0.4980392157, alpha: 0.8225511696)
    }
}

// MARK: - Location Manager Functions
extension ViewController: CLLocationManagerDelegate {

    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        fetchAllWeather()
    }
        
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // setup our location manager
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting user know they have to turn this on
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            break
        case .denied:
            deniedAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            restrictedAlert()
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
}
extension ViewController {
    func restrictedAlert() {
        let alertController = UIAlertController(title: "Restricted", message: "Location Services are resticted on this device", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
    func deniedAlert(){
        let alertController = UIAlertController(title: "Restricted", message: "Location Services were denied for this app, change the location services for this app in your privacy settings", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension Date{
    
    var asString: String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: self)
    }
    
    var asTimeString: String{
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
    
    var asMediumString : String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}




