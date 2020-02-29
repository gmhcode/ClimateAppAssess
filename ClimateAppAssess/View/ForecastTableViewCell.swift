//
//  ForecastTableViewCell.swift
//  ClimateAppAssess
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var day : String?
    var temp : String?
    var weather : Weather? {
        didSet{
            setViews()
        }
    }
    
    func setViews() {
        guard let weather = weather else {print("❇️♊️>>>\(#file) \(#line): guard let failed<<<"); return}
        
        WeatherController.shared.retrieveImageFromCache(weather: weather) { (image) in
            DispatchQueue.main.async {
                self.dayLabel.text = self.day
                self.tempLabel.text = self.temp
                self.iconImageView.image = image
            }
        }
    }
}
