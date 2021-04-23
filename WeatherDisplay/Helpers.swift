//
//  Helpers.swift
//  WeatherDisplay
//
//  Created by john Russell on 4/22/21.
//

import Foundation



enum UserDefaultsKeys
{
    static let fetchedCities = "FetchedCities_key"
}


struct WeatherItem
{
    var cityName:String
    var description:String

    var details:[WeatherDetailItem]
}

struct WeatherDetailItem
{
    var title:String
    var value:String
}


class Helper
{
    static let maxDisplayWeatherItems = 3
    
    static let citiesArray = ["Dunwoody", "Dallas", "Austin"] // san antonio
    
    static func createWeatherDataTestData()->[WeatherItem]
    {
        var details = [
            WeatherDetailItem(title: "Temperature", value: "283.25 K"),
            WeatherDetailItem(title: "Pressure", value: "1025 hpa"),
            WeatherDetailItem(title: "Humidity", value: "53 %"),
            WeatherDetailItem(title: "Min Temperature", value: "282.59 K"),
            WeatherDetailItem(title: "Max Temperature", value: "284.15 K"),
            WeatherDetailItem(title: "Wind Speed", value: "2.5"),
            WeatherDetailItem(title: "Sunrise", value: "1606220332"),
            WeatherDetailItem(title: "Sunset", value: "1606256993")
            
        ]
        
        let struct0 = WeatherItem(cityName: citiesArray[0], description: "Clear Sky", details: details)
        
        
        details = [
            WeatherDetailItem(title: "Temperature", value: "385.55 K"),
            WeatherDetailItem(title: "Pressure", value: "1055 hpa"),
            WeatherDetailItem(title: "Humidity", value: "55 %"),
            WeatherDetailItem(title: "Min Temperature", value: "385.59 K"),
            WeatherDetailItem(title: "Max Temperature", value: "389.15 K"),
            WeatherDetailItem(title: "Wind Speed", value: "5.5"),
            WeatherDetailItem(title: "Sunrise", value: "1606220335"),
            WeatherDetailItem(title: "Sunset", value: "1606256995")
            
        ]
        
        let struct1 = WeatherItem(cityName: citiesArray[1], description: "Cloudy", details: details)
                
        details = [
            WeatherDetailItem(title: "Temperature", value: "187.77 K"),
            WeatherDetailItem(title: "Pressure", value: "857 hpa"),
            WeatherDetailItem(title: "Humidity", value: "77 %"),
            WeatherDetailItem(title: "Min Temperature", value: "87.59 K"),
            WeatherDetailItem(title: "Max Temperature", value: "29.15 K"),
            WeatherDetailItem(title: "Wind Speed", value: "5.7"),
            WeatherDetailItem(title: "Sunrise", value: "1606220337"),
            WeatherDetailItem(title: "Sunset", value: "1606256997")
        ]
        
        let struct2 = WeatherItem(cityName: citiesArray[2], description: "Sunny", details: details)
        
        let array = [struct0, struct1, struct2]
        
        return array
    }

}


