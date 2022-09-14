//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by ArnoldKy on 8/11/22.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, WeatherManagerDelegate {
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    //Variables To save the values from API
    var cityName: String = ""
    var weatherImage: UIImage?
    var cityTemp: String?
    var maxTemp: String?
    var minTemp: String?
    var feelsLike: String?
    var pressure: String?
    var windSpeed: String?
    var humidity: String?
    var weatherDescription: String?
    var weatherCondition: String?
    //var lastloc: CLLocationCoordinate2D?
    
    var weatherManager = WeatherManager()
    //in charge of getting the current location of the phone
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegate to obtain location
        locationManager.delegate = self
        //Ask for user permission for location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        //self.lastloc = locationManager.location?.coordinate
//        print("\(locationManager.location!.coordinate.latitude), HHHHHHHHHeeeeeeerrrrrrrrreeeee")
        
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        //self.lastloc = locationManager.location?.coordinate
    }
    
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        
        //Store the values into a variable to latter be passed on to the DetailView
        self.weatherImage = UIImage(systemName: weather.conditionName)
        self.cityName = weather.cityName
        self.cityTemp = weather.temperatureString
        self.maxTemp = weather.maxTemperatureString
        self.minTemp = weather.minTemperatureString
        self.feelsLike = weather.feelsLikeString
        self.pressure = weather.pressureString
        self.windSpeed = weather.windSpeedString
        self.weatherDescription = weather.description
        self.humidity = weather.humidityString
        self.weatherCondition = weather.conditionName
        
        
        
        
        //Give the values
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailSegue" {
            let DetailVC = segue.destination as! DetailViewController
            DetailVC.cityName = cityName
            DetailVC.weatherImageIcon = weatherImage
            DetailVC.temperatureInString = cityTemp
            DetailVC.maxTemp = maxTemp
            DetailVC.minTemp = minTemp
            DetailVC.feelsLike = feelsLike
            DetailVC.intPressure = pressure
            DetailVC.windSpeed = windSpeed
            DetailVC.weatherDescription = weatherDescription
            DetailVC.humidity = humidity
            DetailVC.weatherCondition = weatherCondition
        }
    }
    
    
}

//MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        //        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        //        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type Something"
            return false
        }
    }
    
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
}





//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        print("@@@@@@@@@@@@@@@@@@@@@@@")
        //        print("Got Location Data")
        
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            //            print(lat)
            //            print(lon)
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            //self.lastloc = locationManager.location?.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
