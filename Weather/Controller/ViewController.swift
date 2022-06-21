//
//  ViewController.swift
//  Weather
//
//  Created by Kakyire on 02/05/2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
   
    

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
   
    var weatherManager = WeatherManager()
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
        
    }
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        
        let city = searchTextField.text!
        searchTextField.text = ""
         
        weatherManager.fetchWeather(city:city )
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    



}


//MARK: - UiTextFieldDelegate
extension ViewController: UITextFieldDelegate{
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(city: city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    
}


//MARK: - WeatherMangerDelegate
extension ViewController : WeatherMangerDelegate{
    
    
    func didUpdateWeather(_ weatherManager:WeatherManager,weather: WeatherModel) {
        
        DispatchQueue.main.async {
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName        }
        
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
}


//MARK: - CCLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print(error)
    }
}
