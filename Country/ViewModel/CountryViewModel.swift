//
//  CountryViewModel.swift
//  Country
//
//  Created by Federico Piccirilli on 16/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation

class CountryViewModel {
    
    let client :ApiService = NativeClient()

    var countryListPresenter: CountryListPresenter = CountryListPresenter()

    var languagesFilterMap = [String : Bool]()
    var regionsFilterMap = [String : Bool]()
    
    func loadCountries(completion: @escaping (Result<[Country], Error>) -> Void){
        client.fetchCountries(completion: {
            [weak self] result in
            switch result {
            case .success(let countries):
                self?.fetchFilterParams(from: countries)
            case .failure(_):
                break
            }
            completion(result)
        })
    }
    
    fileprivate func fetchFilterParams(from countries:[Country]){
        for country in countries {
            for language in country.languages ?? [] {
                if let languageCode = language.iso639_1 {
                    self.languagesFilterMap.updateValue(true, forKey: languageCode)
                }
            }
        }
        for country in countries {
            if let countryRegion = country.region {
                self.regionsFilterMap.updateValue(true, forKey: countryRegion)
            }
        }
    }
        
    func saveFilters(){}
}
