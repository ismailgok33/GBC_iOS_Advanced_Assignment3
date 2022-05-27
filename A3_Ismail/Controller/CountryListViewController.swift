//
//  ViewController.swift
//  A3_Ismail
//
//  Created by Ismail Gok on 2022-05-26.
//

import UIKit

class CountryListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private let reuseIdentifier = "countryCell"
    
    var allCountries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var favoriteCountries = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let dbHelper = CoreDBHelper.getInstance()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        configureUI()
        fetchAllCountries()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.setFavoriteCountries() // Sets the favorite countries if there is any change
        showAllCountries() // When user goes back to main list, it shows All Countries
    }

    // MARK: - Helpers
    
    private func configureUI() {
        self.title = "All Countries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Favorites", style: .plain, target: self, action: #selector(showFavorites))
    }
    
    private func fetchAllCountries() {
        // Fetch all countries from API
        CountryViewModel.shared.fetchAllCountries { countryList, error in
            guard let countryList = countryList, error == nil else {
                print(#function, "Error while fetching all countries: \(error!.localizedDescription)")
                return
            }
            
            self.allCountries = countryList
            
            // Set favorites from CoreData
            self.setFavoriteCountries()
        }
    }
    
    private func isFavorite(country: Country) -> Bool {
        
        if dbHelper.searchFavorite(countryName: country.name) != nil {
            var favoriteCountry = country
            favoriteCountry.isFavorite = true
            favoriteCountries.append(favoriteCountry)
            return true
        }
        return false
    }
    
    private func setFavoriteCountries() {
        
        favoriteCountries = [Country]()
        
        for i in 0 ..< self.allCountries.count {
            self.allCountries[i].isFavorite = isFavorite(country: self.allCountries[i])
        }
    }
    
    private func deleteFavorite(countryName: String) {
        dbHelper.deleteFavorite(countryName: countryName)
        setFavoriteCountries()
    }
    
    // Determine if the current state of the TableView
    private func isViewInFavoriteState() -> Bool {
        return self.title == NavigationTitle.FAVORITES
    }
    
    // Get the current Country in selected row from the current state list
    private func getCurrentCountry(row: Int) -> Country {
        if isViewInFavoriteState() {
            return favoriteCountries[row]
        }
        return allCountries[row]
    }
    
    // MARK: - Selectors
    
    @objc private func showFavorites() {
        
        // load favorites
        self.title = NavigationTitle.FAVORITES
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ButtonTitle.SHOW_ALL, style: .plain, target: self, action: #selector(showAllCountries))
        
        tableView.reloadData()

    }
    
    @objc private func showAllCountries() {
        
        // load all countries
        self.title = NavigationTitle.ALL_COUNTRIES
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: ButtonTitle.SHOW_FAVORITE, style: .plain, target: self, action: #selector(showFavorites))
        
        tableView.reloadData()

    }

}

// MARK: - UITableView Delegate and Datasource functions
extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isViewInFavoriteState() {
            return favoriteCountries.count
        }
        else {
            return allCountries.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let country = getCurrentCountry(row: indexPath.row)
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "\(country.population)"
        
        if country.isFavorite {
            cell.textLabel?.backgroundColor = .systemYellow
            cell.detailTextLabel?.backgroundColor = .systemYellow
        }
        else {
            cell.textLabel?.backgroundColor = .clear
            cell.detailTextLabel?.backgroundColor = .clear
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let country = getCurrentCountry(row: indexPath.row)
        
        if let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? CountryDetailsViewController {
            detailsVC.country = country
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let country = getCurrentCountry(row: indexPath.row)
        
        var countrySize = allCountries.count
        if isViewInFavoriteState() {
            countrySize = favoriteCountries.count
        }
        
        if country.isFavorite {
            if (editingStyle == UITableViewCell.EditingStyle.delete && indexPath.row < countrySize) {
                self.deleteFavorite(countryName: country.name)
            }
        }
        
    }
    
}

