//
//  WeatherManagr.swift
//  punpromotion-assignment
//
//  Created by Panachai Sulsaksakul on 5/27/24.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherData)
}

struct WeatherManager {
//    let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=13.75&longitude=100.50&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
    let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=51.5072&longitude=0.1276&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather() {
        performRequest(with: weatherURL)
    }
    
    func performRequest(with weatherURL: String) {
        // Create URL
        if let url = URL(string: weatherURL) {
            // Create Session
            let session = URLSession(configuration: .default)
            // Give a session & task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                }
                
                if let safeData = data {
                    if let weatherData = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weatherData)
                    }
                }
            }
    
            // Start the task
            task.resume()
        }

    }
    
    func parseJSON(_ weatherData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            return decodedData
        } catch {
            print(error)
            return nil
        }
        
    }

     
}
