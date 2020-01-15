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
    func countryListPresenter(didFinishToLoad countries :[Country], with error: Error?)
}

class CountryListPresenter :NSObject {
    private var model: CountryModel = CountryModel()
    var delegate :CountryListPresenterDelegate?
    fileprivate var isLoading = false
    
    var isFiltering : Bool {
        get{
            return model.isFiltering
        }
    }
    
    func getRegions()->[String]{
        return model.getRegions()
    }
    
    func getLanguages()->[Languages]{
        return model.getLanguages()
    }
    
    func regionFilterActive(key: String)->Bool{
        return model.regionFilterActive(key:key)
    }
    
    func languageFilterActive(key: String)->Bool{
        return model.languageFilterActive(key:key)
    }
    
    func addRegionFilterActive(key: String){
        model.addRegionFilterActive(key:key)
    }
    
    func addLanguageFilterActive(key: String){
        model.addLanguageFilterActive(key:key)
    }
    
    func removeRegionFilterActive(key: String){
        model.removeRegionFilterActive(key:key)
    }
    
    func removeLanguageFilterActive(key: String){
        model.removeLanguageFilterActive(key:key)
    }
    
    func resetFilters(){
        model.resetFilters()
    }
    
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
        guard !isLoading else {
            return
        }
        isLoading = true
        
        model.loadCountries() {
            [weak self] countries, error  in
            self?.isLoading = false
            guard error == nil else {
                self?.delegate?.countryListPresenter(didFinishToLoad: [Country](), with: error)
                return
            }
            self?.displayedCountries = countries
            self?.searchPresenter.unfilteredData = countries
            self?.delegate?.countryListPresenter(didFinishToLoad: countries, with: nil)
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
