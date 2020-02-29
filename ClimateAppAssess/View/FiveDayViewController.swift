//
//  FiveDayViewController.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class FiveDayViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var backButton: UIButton!
    
    var days : [String] = []
    var daysWeatherDict : [String:[List]] = [:]
    var pickedDay = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        setupDataSources()
        setUpViews()
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Setup
    func setUpViews(){
        backButton.layer.cornerRadius = 10
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = #colorLiteral(red: 0.4979877472, green: 0.4980752468, blue: 0.4979762435, alpha: 0.8006670322)
        tableView.layer.cornerRadius = 10
    }
    func setupDataSources() {
        let list = WeatherController.shared.forecast?.list ?? [List]()
        let dataTuple = seperateDaysFrom(list:list)
        days = dataTuple.1
        daysWeatherDict = dataTuple.0
        pickedDay = days[0]
    }
    func setDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
        pickerView.delegate = self
        pickerView.dataSource = self
    }
}


// MARK: - TableView Functions
extension FiveDayViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysWeatherDict[pickedDay]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ForecastTableViewCell else {return UITableViewCell()}
        
        let weatherItem = daysWeatherDict[pickedDay]?[indexPath.row]
        
        let dayDateString =  Date(timeIntervalSince1970: weatherItem?.dt ?? 0).asTimeString
        
        cell.day = dayDateString
        cell.temp = String(daysWeatherDict[pickedDay]?[indexPath.row].main.temp ?? 0) + "°F"
        cell.weather = weatherItem?.weather[0]

        return cell
    }
    
    
    
    
}
// MARK: - PickerController Functions
extension FiveDayViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedDay = days[row]
        tableView.reloadData()
    }
}
fileprivate let formatter = DateFormatter()
// MARK: - Helper Functions
   /// Goes through each list item and separated the individial days of the week into an array and a dictionary which holds the relevant info for that days weather
   func seperateDaysFrom(list: [List]) ->([String:[List]],[String]) {
       var dict : [String:[List]] = [:]
       var array : [String] = []

       for i in list {
        print(i.dt, " 🥶")
           let day = extractDayName(string: dateAsDayString(formatter: formatter, date: Date(timeIntervalSince1970:i.dt)) ?? "")
//           print(day)
           if dict[day] == nil {
               dict[day] = [i]
               array.append(day)
           } else {
               dict[day]?.append(i)
           }
       }
       return (dict,array)
   }
   
   //should contain a day
   func dateAsDayString(formatter: DateFormatter, date:Date) -> String?{
       formatter.dateStyle = .full
        print(formatter.string(from: date), "  🏓")
       return formatter.string(from: date)
   }
   
   /// should return monday or tuesday or wednesday ect
   func extractDayName(string: String) -> String {
       return string.components(separatedBy: ",")[0]
   }
