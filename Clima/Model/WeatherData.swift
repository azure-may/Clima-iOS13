//
//  WeatherData.swift
//  Clima
//
//  Created by Azure May Burmeister on 3/5/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let coord: Coord
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double

}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct Weather: Codable {
    let id: Int
}


