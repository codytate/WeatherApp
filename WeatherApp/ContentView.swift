//
//  ContentView.swift
//  WeatherApp
//
//  Created by Cody Tate on 11/3/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
        
        var body: some View {
            NavigationView {
                VStack(spacing: 20) {
                    TextField("Enter city name", text: $viewModel.city)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .onSubmit {
                            Task {
                                await viewModel
                                    .fetchWeather(city: viewModel.city)
                            }
                        }
                    
                    Button("Get Weather") {
                        Task {
                            await viewModel.fetchWeather(city: viewModel.city)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.city.isEmpty)
                    
                    if viewModel.isLoading {
                        ProgressView("Fetching Weather...")
                    } else if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else if let temp = viewModel.temperature {
                        VStack(spacing: 10) {
                            Text("Temperature: \(temp, specifier: "%.1f")°C")
                                .font(.title2)
                            if let wind = viewModel.windSpeed {
                                Text("Wind Speed: \(wind, specifier: "%.1f") m/s")
                            }
                            if let code = viewModel.weatherCode {
                                Text("Weather Code: \(code)")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                }
                .navigationTitle("Weather App")
            }
        }
}

#Preview {
    ContentView()
}
