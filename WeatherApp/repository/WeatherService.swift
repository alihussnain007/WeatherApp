//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.
//

import Foundation
import Combine
import Alamofire

class WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/"
    private let apiKey = "f01e80368f05c66b03425d3f08ab1a1c"

    func fetchWeatherByCity(city: String) -> AnyPublisher<WeatherResponse, Error> {
          let url = "\(baseURL)weather"
          let parameters: [String: Any] = [
              "q": city,
              "appid": apiKey,
              "units": "metric"
          ]

          return Future { promise in
              AF.request(url, method: .get, parameters: parameters)
                  .validate()
                  .responseDecodable(of: WeatherResponse.self) { response in
                      switch response.result {
                      case .success(let weather):
                          promise(.success(weather))
                      case .failure(let error):
                          promise(.failure(error))
                      }
                  }
          }
          .receive(on: DispatchQueue.main)
          .eraseToAnyPublisher()
      }
    
    

    
    func fetchHourlyWeather(lat: Double, lon: Double) -> AnyPublisher<HourlyWeatherResponse, Error> {
           let url = "\(baseURL)forecast"
           let parameters: [String: Any] = [
               "lat": lat,
               "lon": lon,
               "appid": apiKey,
               "units": "metric"
           ]
           
           return Future { promise in
               AF.request(url, method: .get, parameters: parameters)
                   .validate()
                   .responseDecodable(of: HourlyWeatherResponse.self) { response in
                       switch response.result {
                       case .success(let weather):
                           promise(.success(weather))
                       case .failure(let error):
                           promise(.failure(error))
                       }
                   }
           }
           .receive(on: DispatchQueue.main)
           .eraseToAnyPublisher()
       }
    
    
}

