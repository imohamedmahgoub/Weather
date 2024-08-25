//
//  YourWeather.swift
//  Weather
//
//  Created by Mohamed Mahgoub on 24/08/2024.
//

import SwiftUI

struct YourWeather: View {
    @StateObject private var viewModel = WeatherViewModel()
    var body: some View {
        ZStack{
            SetupBackgroundImage(isDay: viewModel.weatherData.first?.current.isDay)
            VStack{
                SetupWeatherAndCity(cityName: viewModel.weatherData.first?.location.name, currentTemp: viewModel.weatherData.first?.current.tempC, highestTemp: viewModel.weatherData.first?.forecast.forecastday.first?.day.maxtempC, lowestTemp: viewModel.weatherData.first?.forecast.forecastday.first?.day.mintempC, state: viewModel.weatherData.first?.current.condition.text, icon: viewModel.weatherData.first?.current.condition.icon, time: viewModel.weatherData.first?.location.localtime)
                
                if let forcast = viewModel.weatherData.first?.forecast {
                    SetupForecastList(forecast: forcast)
                        .background(Color.clear)
                }
                SetupWeatherDetails(visibility: viewModel.weatherData.first?.current.visKM, humidity: viewModel.weatherData.first?.current.humidity, feelsLike: viewModel.weatherData.first?.current.feelslikeC, pressure: viewModel.weatherData.first?.current.pressureMB)
            }
            .padding(.top,300)
            .foregroundColor(viewModel.weatherData.first?.current.isDay != 0 ? .black : .white)
            .onAppear {
                viewModel.fetchWeatherData()
            }
        }
    }
}

struct SetupBackgroundImage : View{
    let isDay : Int?
    var body : some View {
        if isDay != 0 {
            Image("day", bundle: nil)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }else{
            Image("night", bundle: nil)
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}
struct SetupWeatherAndCity : View {
    let cityName : String?
    let currentTemp : Double?
    let highestTemp : Double?
    let lowestTemp : Double?
    let state: String?
    let icon : String?
    let time : String?
    
    var body: some View {
        VStack{
            Text(cityName ?? "")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(time ?? "")
                .fontWeight(.medium)
                .font(.caption)
            Text("\(currentTemp ?? 0, specifier: "%0.1f")°")
                .font(.largeTitle)
                .fontWeight(.medium)
            Text(state ?? "")
                .bold()
                .font(.title3)
            HStack{
                Text("H:\(highestTemp ?? 0, specifier: "%0.1f")°")
                Text("L:\(lowestTemp ?? 0, specifier: "%0.1f")°")
            }
            if let url = URL(string: "https:" + (icon ?? "")) {
                AsyncImage(url: url)
                    .frame(width: 20,height: 20)
            }
        }
    }
}

struct SetupForecastList : View {
    let forecast: Forecast
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("3-DAY FORECAST")
                .font(.headline)
                .padding(.leading,20)
            Divider().frame(width: 300).background(Color(.white))

            List(forecast.forecastday, id: \.date) { day in
                NavigationLink(destination: ForecastDetailView(hourlyForecast: day.hour)) {
                    HStack {
                        Text(getDayName(from: day.date))
                            .bold()
                        Spacer()
                        Spacer()
                        if let iconURL = URL(string: "https:" + day.day.condition.icon) {
                            AsyncImage(url: iconURL)
                                .frame(width: 32, height: 32)
                        }
                        Spacer()
                        Text("\(day.day.mintempC, specifier: "%.1f")° - \(day.day.maxtempC, specifier: "%.1f")°")
                            .bold()
                    }
                }
                .listRowBackground(Color.clear)
            }
            .listStyle(PlainListStyle())
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
        }
        .padding(.trailing,200)
        .padding(.leading,200)
        .padding(.top,90)
    }
    private func getDayName(from dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Today"
            } else {
                dateFormatter.dateFormat = "EEE"
                return dateFormatter.string(from: date)
            }
        }
        return dateString
    }
}
struct SetupWeatherDetails : View{
    let visibility : Int?
    let humidity : Int?
    let feelsLike : Double?
    let pressure : Int?
    
    var body: some View{
        
        HStack{
            VStack{
                WeatherDetailItem(title: "VISIBILITY", value: "\(visibility ?? 0) km")
                Divider().frame(width: 100)
                    .padding(.bottom,30)
                
                WeatherDetailItem(title: "FEELS LIKE", value: "\(feelsLike ?? 0)°")
            }
            .padding(.trailing,50)
            VStack{
                WeatherDetailItem(title: "HUMIDITY", value: "\(humidity ?? 0)%")
                Divider().frame(width: 100)
                    .padding(.bottom,30)
                WeatherDetailItem(title: "PRESSURE", value: "\(pressure ?? 0) mb")
            }
        }
        .padding(.bottom,320)
    }
}

struct WeatherDetailItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .fontWeight(.semibold)
            Text(value)
                .fontWeight(.semibold)
                .font(.largeTitle)
        }
    }
}


#Preview {
    YourWeather()
}
