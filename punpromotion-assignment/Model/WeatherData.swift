//
//  WeatherData.swift
//  punpromotion-assignment
//
//  Created by Panachai Sulsaksakul on 5/27/24.
//

import Foundation

struct WeatherData: Decodable {
    let current: CurrentResponse
    let hourly: HourlyResponse
}

struct CurrentResponse: Codable {
    let temperature_2m: Double
    let time: String
}

struct HourlyResponse: Codable {
    let time: [String]
    let temperature_2m: [Double]
}
