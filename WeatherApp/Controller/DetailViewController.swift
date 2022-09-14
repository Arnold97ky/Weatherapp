//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/17/22.
//

import UIKit
import CoreLocation
import AVFoundation

class DetailViewController: UIViewController{
    
    var player: AVAudioPlayer!
    
    //Outlets
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //Var for getting the values passed from weatherViewController
    var cityName: String?
    var weatherImageIcon: UIImage?
    var temperatureInString: String?
    var maxTemp: String?
    var minTemp: String?
    var feelsLike: String?
    var intPressure: String?
    var windSpeed: String?
    var humidity: String?
    var weatherDescription: String?
    var weatherCondition: String?
    
    var weatherManager = WeatherManager()
    
    
    func playSound() {
        if weatherCondition == "cloud" || weatherCondition == "cloud" || weatherCondition == "sun.max"{
            let url = Bundle.main.url(forResource: "sunnyDay-", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        } else if weatherCondition == "cloud.drizzle" || weatherCondition == "cloud.rain" || weatherCondition == "cloud.snow"{
            let url = Bundle.main.url(forResource: "rain-", withExtension: "wav")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
        } else {
            let url = Bundle.main.url(forResource: "rain-and-thunder-", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            player.play()
            
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        cityLabel.text = cityName!
        weatherImage.image = weatherImageIcon
        temperature.text = temperatureInString
        maxTemperatureLabel.text = maxTemp
        minTemperatureLabel.text = minTemp
        feelsLikeLabel.text = feelsLike
        pressureLabel.text = intPressure
        windSpeedLabel.text = windSpeed
        descriptionLabel.text = weatherDescription
        humidityLabel.text = humidity
        print(weatherCondition ?? "Not Condition")
        
        
        playSound()
//        player.stop()
    }
}

//MARK: - WeatherManagerDelegate

extension DetailViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.descriptionLabel.text = "weather.cityName"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
