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
        
        // TODO: make the changes when user goes back to the list
        
    }

    // MARK: - Helpers
    
    private func configureUI() {
        self.title = "All Countries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Favorites", style: .plain, target: self, action: #selector(showFavorites))
    }
    
    private func fetchAllCountries() {
        CountryViewModel.shared.fetchAllCountries { countryList, error in
            guard let countryList = countryList, error == nil else {
                print(#function, "Error while fetching all countries: \(error!.localizedDescription)")
                return
            }
            
            self.allCountries = countryList
        }
    }
    
    
    // MARK: - Selectors
    
    @objc private func showFavorites() {
        
        // load favorites
        
        tableView.reloadData()
        
        self.title = "Favorite Countries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show All", style: .plain, target: self, action: #selector(showAllCountries))

    }
    
    @objc private func showAllCountries() {
        
        // load all countries
        
        tableView.reloadData()
        
        self.title = "All Countries"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Favorites", style: .plain, target: self, action: #selector(showFavorites))

    }

}

extension CountryListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        let country = allCountries[indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "\(country.population)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let detailsVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryDetailsViewController") as? CountryDetailsViewController {
            detailsVC.country = allCountries[indexPath.row]
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
}

