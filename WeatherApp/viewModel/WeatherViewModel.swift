//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.

//import Foundation
//import Combine
//
//class WeatherViewModel: ObservableObject {
//    @Published var weatherData: WeatherResponse?
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    private var cancellables = Set<AnyCancellable>()
//    private let weatherService = WeatherService()
//
//    func fetchWeatherByCity(city: String) {
//        isLoading = true
//        errorMessage = nil
//
//        weatherService.fetchWeatherByCity(city: city)
//            .sink(receiveCompletion: { [weak self] completion in
//                self?.isLoading = false
//                switch completion {
//                case .failure(let error):
//                    self?.errorMessage = error.localizedDescription
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] weather in
//                self?.weatherData = weather
//            })
//            .store(in: &cancellables)
//    }
//}



import Foundation
import Combine
import RealmSwift

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var hourlyWeatherData: [HourlyWeatherItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherService = WeatherService()
    private let realm = try! Realm()
    
    func fetchWeatherByCity(city: String, forceRefresh: Bool = false) {
        if NetworkMonitor.shared.isConnected && forceRefresh {
            fetchFromAPI(city: city)
        } else {
            loadFromRealm(city: city)
        }
    }
    
    private func fetchFromAPI(city: String) {
        isLoading = true
        errorMessage = nil
        
        weatherService.fetchWeatherByCity(city: city)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.loadFromRealm(city: city) // Fallback to cached data
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weather in
                self?.weatherData = weather
                self?.saveToRealm(weather: weather)
            })
            .store(in: &cancellables)
    }
    
    private func saveToRealm(weather: WeatherResponse) {
        let weatherRealm = WeatherRealmModel(response: weather)
        try? realm.write {
            realm.add(weatherRealm, update: .modified)
        }
    }
    
    private func loadFromRealm(city: String) {
        if let cachedWeather = realm.object(ofType: WeatherRealmModel.self, forPrimaryKey: city) {
            let weather = WeatherResponse(
                name: cachedWeather.city,
          
                main: WeatherResponse.Main(
                    temp: cachedWeather.temperature,
                    temp_max: cachedWeather.maxTemperature,
                    temp_min: cachedWeather.minTemperature
                ),
                coord: WeatherResponse.Coord(
                    lon: cachedWeather.lon,
                    lat: cachedWeather.lat
                ),
                weather: [WeatherResponse.Weather(icon: cachedWeather.weatherIcon)]
            )
            self.weatherData = weather
        } else if !NetworkMonitor.shared.isConnected {
            self.errorMessage = "No cached data available for \(city)"
        }
    }
    
    
    func fetchHourlyWeather(lat: Double, lon: Double) {
            isLoading = true
            errorMessage = nil
            
            if NetworkMonitor.shared.isConnected {
                weatherService.fetchHourlyWeather(lat: lat, lon: lon)
                    .sink(receiveCompletion: { [weak self] completion in
                        self?.isLoading = false
                        switch completion {
                        case .failure(let error):
                            self?.errorMessage = error.localizedDescription
                            self?.loadHourlyWeatherFromRealm()
                        case .finished:
                            break
                        }
                    }, receiveValue: { [weak self] response in
                        let items = self?.processHourlyData(response) ?? []
                        self?.hourlyWeatherData = items
                        self?.saveHourlyWeatherToRealm(items: items)
                    })
                    .store(in: &cancellables)
            } else {
                loadHourlyWeatherFromRealm()
            }
        }
        
        private func processHourlyData(_ response: HourlyWeatherResponse) -> [HourlyWeatherItem] {
            return response.list.map { hourlyData in
                let time = TimeUtility.convertTimestampToTime(timestamp: Double(hourlyData.dt))
                return HourlyWeatherItem(
                    time: time,
                    temperature: "\(Int(round(hourlyData.main.temp)))°C",
                    icon: hourlyData.weather.first?.icon ?? ""
                )
            }
        }
        
        private func saveHourlyWeatherToRealm(items: [HourlyWeatherItem]) {
            try? realm.write {
                items.forEach { item in
                    let realmModel = HourlyWeatherRealmModel()
                    realmModel.id = "\(weatherData?.name ?? "unknown")_\(item.time)"
                    realmModel.cityName = weatherData?.name ?? "unknown"
                    realmModel.timestamp = Int(item.time) ?? 0
                    realmModel.temperature = Double(item.temperature.replacingOccurrences(of: "°C", with: "")) ?? 0.0
                    realmModel.weatherIcon = item.icon
                    //realmModel.timestamp = Date()
                    realm.add(realmModel, update: .modified)
                }
            }
        }
        
        private func loadHourlyWeatherFromRealm() {
            guard let cityName = weatherData?.name else { return }
            let savedItems = realm.objects(HourlyWeatherRealmModel.self)
                .filter("cityName == %@", cityName)
                .sorted(byKeyPath: "timestamp")
            
            hourlyWeatherData = savedItems.map { item in
                HourlyWeatherItem(
                    time: String(item.timestamp), // Convert the timestamp (Int) to a String for UI display,
                    temperature: "\(Int(round(item.temperature)))°C",
                    icon: item.weatherIcon
                )
            }
        }
}

