//
//  HourlyWeatherCellCollectionViewCell.swift
//  WeatherApp
//
//  Created by Arrivy on 01/01/2025.
//

import UIKit

class HourlyWeatherCell: UICollectionViewCell {
    private let timeLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [timeLabel, iconImageView, temperatureLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 50),
            iconImageView.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 10
        timeLabel.textColor = .white
        temperatureLabel.textColor = .white
    }
    
    func configure(with item: HourlyWeatherItem) {
        timeLabel.text = item.time
        temperatureLabel.text = item.temperature
        loadWeatherIcon(icon: item.icon)
    }
    
    private func loadWeatherIcon(icon: String) {
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self?.iconImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}
