//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Cody Tate on 11/3/25.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var windSpeed: Double?
    @Published var weatherCode: Int?
    @Published var city: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchWeather(city: String) async {
        guard !city.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        
        // Convert city name to coordinates using Open-Meteo's geocoding API
        let geoURL = "https://geocoding-api.open-meteo.com/v1/search?name=\(city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        
        do {
            let (geoData, _) = try await URLSession.shared.data(from: URL(string: geoURL)!)
            if let decodedGeo = try? JSONDecoder().decode(GeoResponse.self, from: geoData),
               let location = decodedGeo.results?.first {
                    
                let lat = location.latitude
                let lon = location.longitude
                                
                // Fetch current weather for the location
                let weatherURL = "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current=temperature_2m,wind_speed_10m,weather_code"
                
                let (data, _) = try await URLSession.shared.data(from: URL(string: weatherURL)!)
                let decodedWeather = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                temperature = decodedWeather.current.temperature_2m
                windSpeed = decodedWeather.current.wind_speed_10m
                weatherCode = decodedWeather.current.weather_code
            } else {
                errorMessage = "City not found."
            }
        } catch {
            errorMessage = "Failed to load weather data."
        }
        
        isLoading = false
    }
}

// MARK: - Helper structs for geocoding
struct GeoResponse: Codable {
    let results: [GeoResult]?
}

struct GeoResult: Codable {
    let latitude: Double
    let longitude: Double
}
