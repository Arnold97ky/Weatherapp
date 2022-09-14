//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/15/22.
//

//Network Manager 4 Steps
//1. Create a URL
//2. Create a URLSession
//3. Give URLSession a task
//4. Start the task



import Foundation
import CoreLocation

//Protocol for the delegate
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=55d141cf5daac6d1b9c944eb4019ea58&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //        1. Create a URL
        if let url = URL(string: urlString) {
            //            2. Create a URLSession
            
            let session = URLSession(configuration: .default)
            
            //           3. Give URLSession a task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            //           4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
           let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let maxTemp = decodedData.main.temp_max
            let minTemp = decodedData.main.temp_min
            let feelsLike = decodedData.main.feels_like
            let pressure = decodedData.main.pressure
            let windSpeed = decodedData.wind.speed
            let humidity = decodedData.main.humidity
            let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, maxTemp: maxTemp, minTemp: minTemp, feelsLike: feelsLike, pressure: pressure, windSpeed: windSpeed, humidity: humidity, description: description)
            
            print(weather.humidity)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}

