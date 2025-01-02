//
//  HourlyWeatherRealmModel.swift
//  WeatherApp
//
//  Created by Arrivy on 01/01/2025.
//

import Foundation
import RealmSwift

class HourlyWeatherRealmModel: Object {
    @Persisted(primaryKey: true) var id: String = ""        // Composite key: cityName_timestamp
    @Persisted var cityName: String = ""                    // City name
    @Persisted var timestamp: Int = 0                       // Unix timestamp
    @Persisted var temperature: Double = 0.0                // Temperature in Celsius
    @Persisted var feelsLike: Double = 0.0                 // Feels like temperature
    @Persisted var minTemp: Double = 0.0                   // Minimum temperature
    @Persisted var maxTemp: Double = 0.0                   // Maximum temperature
    @Persisted var pressure: Int = 0                       // Atmospheric pressure
    @Persisted var humidity: Int = 0                       // Humidity percentage
    @Persisted var weatherId: Int = 0                      // Weather condition ID
    @Persisted var weatherMain: String = ""                // Weather main description
    @Persisted var weatherDescription: String = ""         // Weather detailed description
    @Persisted var weatherIcon: String = ""                // Weather icon ID
    @Persisted var windSpeed: Double = 0.0                 // Wind speed
    @Persisted var windDegree: Int = 0                     // Wind direction
    @Persisted var clouds: Int = 0                         // Cloud coverage
    @Persisted var visibility: Int = 0                     // Visibility
    @Persisted var lastUpdated: Date = Date()              // Last update timestamp
    
    // Convenience initializer to create from API response
    convenience init(cityName: String, hourlyData: HourlyData) {
        self.init()
        self.id = "\(cityName)_\(hourlyData.dt)"
        self.cityName = cityName
        self.timestamp = hourlyData.dt
        self.temperature = hourlyData.main.temp
        self.feelsLike = hourlyData.main.feels_like
        self.minTemp = hourlyData.main.temp_min
        self.maxTemp = hourlyData.main.temp_max
        self.pressure = hourlyData.main.pressure
        self.humidity = hourlyData.main.humidity
        
        if let weather = hourlyData.weather.first {
            self.weatherId = weather.id
            self.weatherMain = weather.main
            self.weatherDescription = weather.description
            self.weatherIcon = weather.icon
        }
        
        self.windSpeed = hourlyData.wind.speed
        self.windDegree = hourlyData.wind.deg
        self.clouds = hourlyData.clouds.all
        self.visibility = hourlyData.visibility
        self.lastUpdated = Date()
    }
}
