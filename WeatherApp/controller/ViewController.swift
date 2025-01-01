//
//  ViewController.swift
//  WeatherApp
//
//  Created by Arrivy on 31/12/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    let gradientLayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyGradient(to: gradientView)
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

