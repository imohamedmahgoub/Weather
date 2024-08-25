//
//  WeatherApp.swift
//  Weather
//
//  Created by Mohamed Mahgoub on 22/08/2024.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                YourWeather()
            }
        }
    }
}
