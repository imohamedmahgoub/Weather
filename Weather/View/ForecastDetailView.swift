//
//  FirstScreen.swift
//  Weather
//
//  Created by Mohamed Mahgoub on 22/08/2024.
//

import SwiftUI

struct ForecastDetailView: View {
    let hourlyForecast: [Current]

    var body: some View {
        List(hourlyForecast, id: \.time) { hour in
            HStack {
                Text(formatTime(hour.time ?? ""))
                    .bold()
                Spacer()
                if let iconURL = URL(string: "https:" + (hour.condition.icon)) {
                    AsyncImage(url: iconURL)
                        .frame(width: 32, height: 32)
                }
                Spacer()
                Text("\(hour.tempC, specifier: "%.1f")°C")
                    .bold()
            }
        }
        .background(Color.cyan)
        .navigationTitle("Weather per hour")
    }

    private func formatTime(_ timeString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let date = dateFormatter.date(from: timeString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                let currentHour = calendar.component(.hour, from: Date())
                let forecastHour = calendar.component(.hour, from: date)
                
                if currentHour == forecastHour {
                    return "Now"
                }
            }
            dateFormatter.dateFormat = "h a"
            return dateFormatter.string(from: date)
        }
        return timeString
    }
}

