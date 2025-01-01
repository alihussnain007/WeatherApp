//
//  WeatherEntity.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.
//

import Foundation
import RealmSwift

class WeatherEntity: Object {
    @objc dynamic var cityName: String = ""
    @objc dynamic var temperature: Double = 0.0
    @objc dynamic var maxTemperature: Double = 0.0
    @objc dynamic var minTemperature: Double = 0.0
    @objc dynamic var icon: String = ""

    override static func primaryKey() -> String? {
        return "cityName"
    }
}
