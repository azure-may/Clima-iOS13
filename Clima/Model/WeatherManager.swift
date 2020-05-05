//
//  WeatherManager.swift
//  Clima
//
//  Created by Azure May Burmeister on 3/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

struct WeatherManager {
    let appid: String = "d5ffe0d39cede88220243c2f8441d732"
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(_ location: String) {
        let urlString: String = "\(weatherURL)q=\(location)&appid=\(appid)&units=imperial"
        let urlQuery = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        performRequest(urlQuery)
    }
    
    func fetchWeather(_ lat: Double, _ lon: Double) {
        let urlString: String = "\(weatherURL)lat=\(lat)&lon=\(lon)&appid=\(appid)&units=imperial"
        performRequest(urlString)
    }
    
    func performRequest(_ urlQuery: String) {
        if let url = URL(string: urlQuery) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let code = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionCode: code, cityName: name, temperature: temp)
            return weather
        } catch {
            self.delegate?.didFailWithError(error)
            return nil
        }
    }
}
