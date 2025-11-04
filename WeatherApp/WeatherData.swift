//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Cody Tate on 11/3/25.
//

import Foundation

struct WeatherResponse: Codable {
    let current: CurrentWeather
}

struct CurrentWeather: Codable {
    let temperature_2m: Double
    let wind_speed_10m: Double
    let weather_code: Int
}
