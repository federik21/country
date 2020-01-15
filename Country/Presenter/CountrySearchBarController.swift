//
//  SearchBarPresenter.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import UIKit

protocol CountrySearchDelegate {
    func countrySearch(didCompleteWithCountries countries:[Country])
}

class CountrySearchBarController: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
    
    var unfilteredData = [Country]()
    var delegate :CountrySearchDelegate?
    var isFiltering = false
    var searchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.searchBar.tintColor = UIColor.black
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.setUp()
        
    }
    
    func setUp() {
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchString = searchController.searchBar.text, isFiltering {
            self.search(for:searchString)
        }
    }
    
    func search(for searchString:String){
            let filteredData = self.unfilteredData.filter({ (country) -> Bool in
                guard let name = country.name else {return false}
                return ((name.range(of: searchString, options: .caseInsensitive) != nil))
            })
            delegate?.countrySearch(didCompleteWithCountries: filteredData)

    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: self.searchController)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isFiltering = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        searchController.searchBar.text = ""
        delegate?.countrySearch(didCompleteWithCountries: unfilteredData)
    }
    
    func closeSearch(){
        self.searchController.isActive = false
    }
    
}
