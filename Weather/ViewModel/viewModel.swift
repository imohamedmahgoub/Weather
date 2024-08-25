//
//  viewModel.swift
//  Weather
//
//  Created by Mohamed Mahgoub on 22/08/2024.
//

import Foundation

@available(iOS 13.0, *)
class WeatherViewModel : ObservableObject {
    @Published var weatherData: [WeatherResponse] = []
    private let networkManager : NetworkManagerProtocol = NetworkManager()
    
    func fetchWeatherData() {
        networkManager.fetchData { [weak self] data in
            DispatchQueue.main.async {
                self?.weatherData = [data]
            }
        }
    }
}
