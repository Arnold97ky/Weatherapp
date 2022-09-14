//
//  WeatherData.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/15/22.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let coord: Coord
    let weather: [Weather]
    let wind: Wind
    
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct Coord: Decodable  {
    
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let description: String
    let id: Int
}

struct Wind: Decodable {
    let speed: Double
}
