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
    private let dbHelper = CoreDBHelper.getInstance()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        let title = country?.name ?? "Details"
        let countryName = country?.name ?? "N/A"
        let capital = country?.capital ?? "N/A"
        let countryCode = country?.countryCode ?? "N/A"
        let area = country?.area ?? 0
        
        self.title = title
        
        self.countryName.text = countryName
        self.capital.text = capital
        self.countryCode.text = countryCode
        if country?.population == -1 {
            self.population.text = "N/A"
        }
        else {
            self.population.text = "\(country?.population ?? -1)"
        }
        
        showCapitalOnMap(latlng: country?.latlng ?? [Double](), countryName: countryName, capital: capital, area: area)
        
        if self.country?.isFavorite == true {
            disableFavoriteButton()
        }
        
    }
    
    // Show Capital of the Country
    private func showCapitalOnMap(latlng: [Double], countryName: String, capital: String, area: Double) {
        if latlng.count > 1 {
            
            let lat = latlng[0]
            let lng = latlng[1]
            
            let centerOfMapCoordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            
            // Adjusts the visible region by the AREA data from the country data to include all of the country into the view
            let visibleRegion = MKCoordinateRegion(center: centerOfMapCoordinate, latitudinalMeters: CLLocationDistance(exactly: area)!, longitudinalMeters: CLLocationDistance(exactly: area)!)
            
            self.mapView.setRegion(visibleRegion, animated: true)
            
            let mapMarker = MKPointAnnotation()
            mapMarker.coordinate = centerOfMapCoordinate
            mapMarker.title = "The capital of \(countryName) is \(capital)"
            self.mapView.addAnnotation(mapMarker)
        }
    }
    
    private func setFavoriteButtonStyle(title: String, color: UIColor) {
        self.favoriteButton.setTitle(title, for: .normal)
        self.favoriteButton.tintColor = color
    }
    
    private func disableFavoriteButton() {
        setFavoriteButtonStyle(title: ButtonTitle.DISABLED_BUTTON_TEXT, color: .disabledButtonColor)
        self.favoriteButton.isEnabled = false
    }
    
    
    // MARK: - Actions
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        print(#function, "DEBUG: favorite button is tapped..")
        
        if country?.isFavorite == false {
            if let countryName = self.countryName.text {
                dbHelper.insertFavorite(countryName: countryName)
                disableFavoriteButton()
            }
            
        }

}
