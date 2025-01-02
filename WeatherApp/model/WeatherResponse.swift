//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.
//

import Foundation

struct WeatherResponse: Codable {
    struct Main: Codable {
        let temp: Double
        let temp_max: Double
        let temp_min: Double
    }

    struct Weather: Codable {
        let icon: String
    }
    struct Coord: Codable {
        let lon: Double
        let lat: Double
    }

    let name: String
    let main: Main
    let coord : Coord
    let weather: [Weather]
}




struct HourlyWeatherResponse: Codable {
    let list: [HourlyData]      // List of hourly weather forecasts
    let city: City              // City information
}

// Model for hourly weather data entries
struct HourlyData: Codable {
    let dt: Int                 // Time of forecast, Unix timestamp
    let main: Main              // Main weather metrics
    let weather: [Weather]      // Weather conditions
    let wind: Wind              // Wind information
    let clouds: Clouds          // Cloud coverage
    let visibility: Int         // Visibility in meters
}

// Model for city information
struct City: Codable {
    let id: Int                 // City ID
    let name: String            // City name
    let coord: Coord            // City coordinates
    let country: String         // Country code (e.g., "US")
    let population: Int         // City population
    let timezone: Int           // Timezone offset from UTC
    let sunrise: Int            // Sunrise time, Unix timestamp
    let sunset: Int             // Sunset time, Unix timestamp
}

// Model for geographical coordinates
struct Coord: Codable {
    let lon: Double            // Longitude
    let lat: Double            // Latitude
}

// Model for main weather metrics
struct Main: Codable {
    let temp: Double           // Current temperature
    let feels_like: Double     // Perceived temperature
    let temp_min: Double       // Minimum temperature
    let temp_max: Double       // Maximum temperature
    let pressure: Int          // Atmospheric pressure (hPa)
    let humidity: Int          // Humidity percentage
    let sea_level: Int?        // Pressure at sea level
    let grnd_level: Int?       // Pressure at ground level
}

// Model for weather conditions
struct Weather: Codable {
    let id: Int               // Weather condition ID
    let main: String          // Weather parameter (Rain, Snow, etc.)
    let description: String   // Weather description
    let icon: String         // Weather icon ID
}

// Model for wind information
struct Wind: Codable {
    let speed: Double         // Wind speed (meter/sec)
    let deg: Int             // Wind direction (degrees)
}

// Model for cloud coverage
struct Clouds: Codable {
    let all: Int             // Cloudiness percentage
}

// Simplified model for UI display
struct HourlyWeatherItem {
    let time: String         // Formatted time (e.g., "3:00 PM")
    let temperature: String  // Formatted temperature (e.g., "23°C")
    let icon: String        // Weather icon ID
}


