//
//  WeatherManager.swift
//  Weather
//
//  Created by Kakyire on 03/05/2022.
//

import Foundation
import CoreLocation


protocol WeatherMangerDelegate {
    func didUpdateWeather (_ weatherManager:WeatherManager,weather:WeatherModel)
    func didFailedWithError(error:Error)
}
struct WeatherManager {
    
    private let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=804301661169d4342bb5a78b2e7763f1&units=metric"
    
    func fetchWeather(city:String)  {
        let apiUrl = "\(baseUrl)&q=\(city)"
        
        performRequest(with: apiUrl)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees,longitude: CLLocationDegrees){
        let apiUrl = "\(baseUrl)&lat=\(latitude)&lon=\(longitude)"
        
        performRequest(with: apiUrl)
        
    }
    
    var delegate : WeatherMangerDelegate?
    
    private func performRequest(with apiUrl:String)  {
        
        if let url = URL(string: apiUrl){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url){(data,response,error) in
                
                if error != nil{
                    delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let  weather =  pasrseJson(safeData){
                        delegate?.didUpdateWeather(self,weather: weather)
                    }
                }
                
            }
            task.resume()
        }
        
        
        
    }
    
    func pasrseJson(_ weatherData:Data)-> WeatherModel?  {
        
        let decoder = JSONDecoder()
        do{
            
           let decodedData = try  decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temperature = decodedData.main.temp
            
           return WeatherModel(cityName: name, temperature: temperature, conditionId: id)
                        
        }catch{
            delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
   
    
    
}
