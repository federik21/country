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
    
    weak var viewModel : CountryViewModel?
    var delegate :CountryListPresenterDelegate?
    var displayedCountries = [Country]() {
        willSet {
            DispatchQueue.main.async{
                [weak self] in
                if self?.displayedCountries.count ?? 0 > 0 {
                    self?.tableView?.isHidden = false
                }
                else {
                    self?.tableView?.isHidden = true
                }
                self?.tableView?.reloadData()
            }
        }
    }
    

    weak var tableView: UITableView?
    
    private let searchPresenter = CountrySearchBarController()
    
    init(viewModel: CountryViewModel) {
        self.viewModel = viewModel
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
    }

    func loadData(){
        viewModel?.loadCountries() {
            [weak self] countries in
                self?.displayedCountries = countries
                self?.searchPresenter.unfilteredData = countries
            }
        }
    
    func closeSearch(){
        searchPresenter.closeSearch()
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
