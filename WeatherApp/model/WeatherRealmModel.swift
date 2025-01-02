//
//  WeatherRealmModel.swift
//  WeatherApp
//
//  Created by Arrivy on 01/01/2025.
//

import Foundation

import RealmSwift

class WeatherRealmModel: Object {
    @Persisted(primaryKey: true) var city: String = ""
    @Persisted var temperature: Double = 0.0
    @Persisted var maxTemperature: Double = 0.0
    @Persisted var minTemperature: Double = 0.0
    @Persisted var lon: Double = 0.0
    @Persisted var lat: Double = 0.0
    @Persisted var weatherIcon: String = ""
    @Persisted var lastUpdated: Date = Date()
    
    convenience init(response: WeatherResponse) {
        self.init()
        self.city = response.name
        self.temperature = response.main.temp
        self.maxTemperature = response.main.temp_max
        self.minTemperature = response.main.temp_min
        self.lon = response.coord.lon
        self.lat = response.coord.lat
        self.weatherIcon = response.weather.first?.icon ?? ""
        self.lastUpdated = Date()
    }
}
