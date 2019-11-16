//
//  CountryListPresenter.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

protocol CountryListPresenterDelegate {
    func countryListPresenter(didSelectCountry country: Country)
}

class CountryListPresenter :NSObject {
    
    var viewModel : CountryViewModel?
    var delegate :CountryListPresenterDelegate?
    var displayedCountries = [Country]() {
        didSet {
            DispatchQueue.main.async{
                [weak self] in
                if self?.displayedCountries.count ?? 0 > 0 {
                    self?.tableView?.isHidden = false
                    self?.tableView?.reloadData()
                }
                else {
                    //TODO: Inform user
                }
            }
        }
    }
    

    weak var tableView: UITableView?
    
    private let searchPresenter = CountrySearchBarController()
    
    override init() {
        super.init()
    }
    
    func bind(tableView: UITableView){
        self.tableView = tableView
        self.tableView?.isHidden = true
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        self.tableView?.tableHeaderView = self.searchPresenter.searchController.searchBar
        self.searchPresenter.searchController.searchBar.sizeToFit()
        self.searchPresenter.delegate = self
        
        loadData()
    }

    func loadData(){
        viewModel?.loadCountries() {
            [weak self] result in
            switch result {
            case .success(let countries):
                self?.displayedCountries = countries
                self?.searchPresenter.unfilteredData = countries
            case .failure(let error):
                self?.handleLoadCountriesError(error: error)
            }
        }
    }
    
    func handleLoadCountriesError(error : Error) {
        // TODO
    }
    
}


extension CountryListPresenter: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryTVC
        let data = displayedCountries[indexPath.row]
        cell.textLabel?.text = data.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let country = displayedCountries[indexPath.row]
        self.delegate?.countryListPresenter(didSelectCountry: country)
    }
}

extension CountryListPresenter :CountrySearchDelegate{
    func countrySearch(didCompleteWithCountries countries: [Country]) {
        self.displayedCountries = countries
        self.tableView?.reloadData()
    }
}
