//
//  ViewController.swift
//  punpromotion-assignment
//
//  Created by Panachai Sulsaksakul on 5/27/24.
//

import UIKit

class ViewController: UIViewController {
    
    // Objects
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var mainTemp: UILabel!
    
    // Protocol
    var weatherManager = WeatherManager()
    
    // Properties to calculate the weekdays and temperature (Hard Code)
    var arrayTemp = [Double]()
    var temp2DArray = [[Double]]()
    var indexTempArr = 0
    var minMaxArr = [[Int?]]()
    var arrayDateTime = [String]()
    var arrayDate = [String]()
    
    // Properties to display weekdays and temperature in table's cell
    var displayDate = [String]()
    var displayWeekDays = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        weatherManager.delegate = self
        weatherManager.fetchWeather()
    }
}

// MARK: - Calculation methods (hard code)

extension ViewController {
    func createDateArr() {
        var temp = 0
        for i in 0...6 {
            if i == 0 {
                arrayDate.append(arrayDateTime[i])
            } else {
                temp += 24
                arrayDate.append(arrayDateTime[temp])
            }
        }
//        print(arrayDateTime)
//        print("arrayDate: ", arrayDate)
    }
    
    func create2DTempArr() {
        var output = [Double]()
        for (index, value) in arrayTemp.enumerated() {
            if (index + 1) % 24 == 0 {
                output.append(value)
                temp2DArray.append(output)
                output = [Double]()
//                print("inner: ", index)
            }
            output.append(value)
//            print("outer", index)
        }
        
//        print("Last Output: ", output)
//        print("temp2DArray: ", temp2DArray)
        findMinMaxTemp()
    }
    
    func findMinMaxTemp() {
        for arr in temp2DArray {
            if let min = arr.min(), let max = arr.max() {
                minMaxArr.append([Int(min), Int(max)])
            }
        }
//        print(minMaxArr)
    }
}

// MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate {
    // Update main temperature (large text)
    func didUpdateWeather(_ WeatherManager: WeatherManager, weather: WeatherData) {
        arrayTemp = weather.hourly.temperature_2m
        arrayDateTime = weather.hourly.time

        create2DTempArr()
        createDateArr()
        subStringDate()
        subStringWeekDay()
        
        DispatchQueue.main.async {
            self.mainTemp.text = String(weather.current.temperature_2m)
            self.table.reloadData()
        }
    }
}

// MARK: - Substring methods (weekday & date)

extension ViewController {
    func subStringWeekDay() {
        // Step 1: Create a DateFormatter for the input date string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        for index in arrayDate {
            // Step 2: Convert the input string to a Date object
            if let date = inputFormatter.date(from: index) {
                // Step 3: Create a DateFormatter for the desired output format
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "EEEE"
                
                // Step 4: Convert the Date object back to a string in the desired format
                let outputDateString = outputFormatter.string(from: date)

                displayWeekDays.append(outputDateString)
//                print("WEEKDAY", displayWeekDays)
                
            } else {
                print("Invalid date string")
            }
        }
        
    }
    
    func subStringDate() {
        // Step 1: Create a DateFormatter for the input date string
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        for index in arrayDate {
            // Step 2: Convert the input string to a Date object
            if let date = inputFormatter.date(from: index) {
                // Step 3: Create a DateFormatter for the desired output format
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "d/M"
                
                // Step 4: Convert the Date object back to a string in the desired format
                let outputDateString = outputFormatter.string(from: date)

                displayDate.append(outputDateString)
//                print(displayDate)
                
            } else {
                print("Invalid date string")
            }
        }
        
    }
}

// MARK: - TableView

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WeatherTableViewCell
        cell.date.text = displayDate[indexPath.row]
        cell.weekDay.text = displayWeekDays[indexPath.row]
        if let min = minMaxArr[indexPath.row][0], let max = minMaxArr[indexPath.row][1] {
            cell.temp.text = String(min) + "°/" + String(max) + "°"
            
        }
        return cell
    }
}
