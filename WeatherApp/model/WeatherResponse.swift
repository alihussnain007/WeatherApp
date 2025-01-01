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

    let name: String
    let main: Main
    let weather: [Weather]
}

