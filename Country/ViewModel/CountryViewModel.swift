//
//  CountryViewModel.swift
//  Country
//
//  Created by Federico Piccirilli on 16/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation

class CountryViewModel {
    
    fileprivate var client :ApiService

    private var countries = [Country]()
    var languagesFilterMap = [String : Bool]()
    var regionsFilterMap = [String : Bool]()
    
    fileprivate var dataDownloaded = false
    var isFiltering = false
    
    init(service: ApiService? = NativeClient()) {
        client = service ?? NativeClient()
    }
    
    func loadCountries(completion: @escaping ([Country]) -> Void){
        guard !dataDownloaded else {
            completion(self.isFiltering ? self.getFilteredCountries() : countries )
            return
        }
        client.fetchCountries(completion: {
            [weak self] result in
            switch result {
            case .success(let countries):
                guard let self = self else {
                    completion([])
                    return
                }
                self.dataDownloaded = true
                self.countries = countries
                self.fetchFilterParams(from: countries)
                completion(self.isFiltering ? self.getFilteredCountries() : countries )
            case .failure(_):
                break
            }
        })
    }
    
    fileprivate func fetchFilterParams(from countries:[Country]){
        for country in countries {
            for language in country.languages ?? [] {
                if let languageCode = language.iso639_1 {
                    self.languagesFilterMap.updateValue(false, forKey: languageCode)
                }
            }
        }
        for country in countries {
            if let countryRegion = country.region {
                self.regionsFilterMap.updateValue(false, forKey: countryRegion)
            }
        }
    }
    
    func getFilteredCountries()->[Country]{
        return countries.filter({
            [weak self] country in
            var languageFound = false
            for language in country.languages ?? [] {
                if self?.languagesFilterMap[language.iso639_1 ?? ""] == true {
                    languageFound = true
                    break
                }
            }
            return (self?.regionsFilterMap[country.region ?? ""] == true) || languageFound
        })
    }
}
