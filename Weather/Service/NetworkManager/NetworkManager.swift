//
//  NetworkManager.swift
//  Weather
//
//  Created by Mohamed Mahgoub on 22/08/2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchData(handler: @escaping ((WeatherResponse) -> Void))
}

class NetworkManager : NetworkManagerProtocol{
    
    func fetchData(handler: @escaping ((WeatherResponse) -> Void)) {
        guard let url = createURL() else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request) { data, _, _ in
            guard let data else { return }
            self.parseData(data: data, handler: handler)
        }
        task.resume()
    }
    
    private func createURL() -> URL? {
        let longitude = 31.0409
        let latitude = 31.3785
        let apiKey = "e4c83b3aec244e7bb2a120019242208"
        let url = "http://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(longitude),\(latitude)&days=3&aqi=yes&alerts=no"
        return URL(string: url)
    }
    
    private func parseData(data: Data, handler: @escaping ((WeatherResponse) -> Void)) {
        do {
            let decodedData = try JSONDecoder().decode(WeatherResponse.self, from: data)
            handler(decodedData)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct EmptyResponse : Codable {
    
}


