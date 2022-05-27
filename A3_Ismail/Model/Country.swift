//
//  Country.swift
//  A3_Ismail
//
//  Created by Ismail Gok on 2022-05-26.
//

import Foundation

struct Country: Decodable {
    let name: String
    let capital: String
    let population: Int
    let countryCode: String
    let latlng: [Double]
    let area: Double
    var isFavorite = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case capital
        case population
        case countryCode = "alpha3Code"
        case latlng
        case area
    }
    
    init(from decoder: Decoder) throws {
        let countryContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try countryContainer.decodeIfPresent(String.self, forKey: .name) ?? "N/A"
        self.capital = try countryContainer.decodeIfPresent(String.self, forKey: .capital) ?? "N/A"
        self.population = try countryContainer.decodeIfPresent(Int.self, forKey: .population) ?? -1
        self.countryCode = try countryContainer.decodeIfPresent(String.self, forKey: .countryCode) ?? "N/A"
        self.latlng = try countryContainer.decodeIfPresent([Double].self, forKey: .latlng) ?? [Double]()
        self.area = try countryContainer.decodeIfPresent(Double.self, forKey: .area) ?? 0
    }
}
