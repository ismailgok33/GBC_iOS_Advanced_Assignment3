//
//  CountryDetailsViewController.swift
//  A3_Ismail
//
//  Created by Ismail Gok on 2022-05-26.
//

import UIKit
import MapKit
import CoreLocation

class CountryDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var capital: UILabel!
    @IBOutlet weak var countryCode: UILabel!
    @IBOutlet weak var population: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Properties

    var country: Country?
    private let geocoder = CLGeocoder()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        self.title = country?.name ?? "Details"
        
        self.countryName.text = country?.name ?? "N/A"
        self.capital.text = country?.capital ?? "N/A"
        self.countryCode.text = country?.countryCode ?? "N/A"
        if country?.population == -1 {
            self.population.text = "N/A"
        }
        else {
            self.population.text = "\(country?.population ?? -1)"
        }
        
        // TODO: set Favorite Button title according to its favorite state
        
    }
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print(#function, "DEBUG: favorite button is tapped..")
    }
    
    // MARK: - Selectors

}
