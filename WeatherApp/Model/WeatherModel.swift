//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/16/22.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let maxTemp: Double
    let minTemp: Double
    let feelsLike: Double
    let pressure: Int
    let windSpeed: Double
    let humidity: Int
    let description: String
    
    
    
    
    //Conver Double Values to String Values and reduce it to One decimal place
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    var maxTemperatureString: String {
        return String(format: "%.1f", maxTemp)
    }
    var minTemperatureString: String {
        return String(format: "%.1f", minTemp)
    }
    var feelsLikeString: String {
        return String(format: "%.1f", feelsLike)
    }
    var pressureString: String {
        return String(pressure)
    }
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    var humidityString: String {
        return String(humidity)
    }
    
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
}
