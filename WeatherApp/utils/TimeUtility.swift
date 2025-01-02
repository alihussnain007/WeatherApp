//
//  TimeUtility.swift
//  WeatherApp
//
//  Created by Arrivy on 01/01/2025.
//

import Foundation

class TimeUtility {
    static func convertTimestampToTime(timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: date)
    }
}
