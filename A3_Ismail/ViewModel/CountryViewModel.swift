//
//  CountryViewModel.swift
//  A3_Ismail
//
//  Created by Ismail Gok on 2022-05-26.
//

import Foundation

class CountryViewModel {
    
    static let shared = CountryViewModel()
    
    func fetchAllCountries(completion: @escaping ([Country]?, Error?) -> Void) {
        guard let apiURL = URL(string: API.fetchUrl) else {
            print(#function, "Unable to generate the URL!")
            return
        }
        
        URLSession.shared.dataTask(with: apiURL) { data, response, error in
            print("DEBUG: apiURL = \(apiURL)")
            guard let data = data, error == nil else {
                print(#function, error?.localizedDescription)
                completion(nil, error)
                return
            }
            
            do {
                let countryList = try JSONDecoder().decode([Country].self, from: data)
                completion(countryList, nil)
            }
            catch let error {
                print(#function, error.localizedDescription)
                completion(nil, error)
            }

        }.resume()
    }
    
}
