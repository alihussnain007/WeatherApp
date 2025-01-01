//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.
//

import UIKit
import Combine
import RealmSwift


class MainViewController: UIViewController {
    private var viewModel = WeatherViewModel()
    private var cancellables = Set<AnyCancellable>()
    private let cityNameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let maxTempLabel = UILabel()
    @IBOutlet weak var textFieldCity: UITextField!
    private let minTempLabel = UILabel()
    private let weatherIcon = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var viewGradient: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient(to: viewGradient)
        setupUI()
        bindViewModel()
       
    }
    
    @IBAction func searchButtonClick(_ sender: UIButton) {
        viewModel.fetchWeatherByCity(city: textFieldCity.text ?? "Lahore") // Example city
    }
    private func setupUI() {
           view.backgroundColor = .white
           let stackView = UIStackView(arrangedSubviews: [cityNameLabel, temperatureLabel, maxTempLabel, minTempLabel, weatherIcon])
           stackView.axis = .vertical
           stackView.alignment = .center
           stackView.spacing = 16

           view.addSubview(stackView)
           view.addSubview(activityIndicator)

           stackView.translatesAutoresizingMaskIntoConstraints = false
           activityIndicator.translatesAutoresizingMaskIntoConstraints = false

           NSLayoutConstraint.activate([
               stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
               activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ])
       }

       private func bindViewModel() {
           viewModel.$weatherData
               .sink { [weak self] weather in
                   guard let weather = weather else { return }
                   self?.updateUI(with: weather)
               }
               .store(in: &cancellables)

           viewModel.$isLoading
               .sink { [weak self] isLoading in
                   self?.activityIndicator.isHidden = !isLoading
                   isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
               }
               .store(in: &cancellables)

           viewModel.$errorMessage
               .sink { [weak self] errorMessage in
                   guard let errorMessage = errorMessage else { return }
                   self?.showErrorAlert(message: errorMessage)
               }
               .store(in: &cancellables)
       }

       private func updateUI(with weather: WeatherResponse) {
           cityNameLabel.text = weather.name
           temperatureLabel.text = "\(weather.main.temp)°C"
           maxTempLabel.text = "Max: \(weather.main.temp_max)°C"
           minTempLabel.text = "Min: \(weather.main.temp_min)°C"
           loadWeatherIcon(icon: weather.weather.first?.icon ?? "")
       }

       private func loadWeatherIcon(icon: String) {
           guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
           URLSession.shared.dataTask(with: url) { data, _, _ in
               if let data = data {
                   DispatchQueue.main.async {
                       self.weatherIcon.image = UIImage(data: data)
                   }
               }
           }.resume()
       }

       private func showErrorAlert(message: String) {
           let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default))
           present(alert, animated: true)
       }
    
    func applyGradient(to view: UIView) {
        gradientLayer.frame = view.bounds
        
        // Define the gradient colors (adjust to match the screenshot's colors)
        gradientLayer.colors = [
            UIColor(red: 0.09, green: 0.07, blue: 0.32, alpha: 1.0).cgColor, // Dark purple
            UIColor(red: 0.23, green: 0.10, blue: 0.46, alpha: 1.0).cgColor, // Mid purple
            UIColor(red: 0.47, green: 0.18, blue: 0.56, alpha: 1.0).cgColor, // Light purple
        ]
        
        // Define gradient locations
        gradientLayer.locations = [0.0, 0.5, 1.0] // Start, mid, and end points
        
        // Define the gradient direction
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Top-center
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)   // Bottom-center
        
        // Add the gradient layer to the view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

  

}
