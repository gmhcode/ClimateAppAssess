//
//  ClimateAppAssessTests.swift
//  ClimateAppAssessTests
//
//  Created by Greg Hughes on 2/28/20.
//  Copyright © 2020 Greg Hughes. All rights reserved.
//

import XCTest
@testable import ClimateAppAssess

class ClimateAppAssessTests: XCTestCase {

    var lists : [List] = []
    
    func createTestStructs() -> [List]{
        let list1 = List(dt: 1582869600, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list2 = List(dt: 1582880400, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list3 = List(dt: 1582977600, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list4 = List(dt: 1583074800, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list5 = List(dt: 1583182800, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list6 = List(dt: 1583290800, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        let list7 = List(dt: 1583290800, main: Main(temp: 22.89), weather: [Weather(description: "its weather", id: 1, icon: "10d")])
        return [list1,list2,list3,list4,list5,list6,list7]
    }
    ///Makes sure something is fetched
    func testFetchWeather() {
        WeatherController.shared.fetchWeather(long: 40.296142578125, lat: -111.67133965431297) { (weatherdata) in
            XCTAssertTrue(weatherdata != nil)
        }
    }
    ///Makes sure something is fetched
    func testfetch5DayWeather(){
        WeatherController.shared.fetch5DayWeather(long: 40.296142578125, lat: -111.67133965431297) { (forecast) in
            XCTAssertTrue(forecast != nil)
        }
    }
    ///Makes sure the amount of days contained the dictionary and the array keys are greater than or equal to 5 and less than or equal to 6. It also checks for doubles
    func testSeperateDays() {

        let lists = createTestStructs()
        let tuple = seperateDaysFrom(list: lists)
        
        
        let testBool = tuple.0.keys.count >= 5
            && tuple.1.count >= 5
            && tuple.0.keys.count <= 6
            && tuple.1.count <= 6
            //makes sure there are no duplicates
            && tuple.1.count == Set(tuple.1).count
        
        XCTAssertTrue(testBool)
    }
    ///Tests to make sure the string returned from dateAsDayString contains a day of the week
    func testDateAsDayString() {
            
        let lists = createTestStructs()
        let tuple = seperateDaysFrom(list: lists)
        let formatter = DateFormatter()
        let array = Array(tuple.0.values)
        let date = Date(timeIntervalSince1970:array[0][0].dt)
        let daysArray = ["Monday","Tueday","Wednesday","Thursday","Friday","Saturday","Sunday"]
        let dateArray = dateAsDayString(formatter: formatter, date: date)?.components(separatedBy: ",")
        
        let testBool = daysArray.contains(where: {dateArray!.contains($0)})
        XCTAssertTrue(testBool)
    }
    ///Needs to Extract the day of the week
    func testExtractDayName(){
       let testBool = extractDayName(string: "Tuesday, March 3, 2020") == "Tuesday"
        
       XCTAssertTrue(testBool)
    }
    //image needs to not be nil
    func testFetchWeatherIcons() {
        WeatherController.shared.fetchWeatherIcons(weather: createTestStructs()[0].weather[0]) { (image) in
            let testBool = image != nil
            XCTAssertTrue(testBool)
        }
    }

}
