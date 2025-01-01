//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherResponse?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let weatherService = WeatherService()

    func fetchWeatherByCity(city: String) {
        isLoading = true
        errorMessage = nil

        weatherService.fetchWeatherByCity(city: city)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] weather in
                self?.weatherData = weather
            })
            .store(in: &cancellables)
    }
}

