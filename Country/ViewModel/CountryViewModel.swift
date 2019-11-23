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
    
    var languagesFilter = [String : String]()
    var regionsFilter = [String: String]()
    
    var isFiltering : Bool {
        get{
            return languagesFilter.count + regionsFilter.count > 0
        }
    }
        
    init(service: ApiService? = NativeClient()) {
        client = service ?? NativeClient()
    }
    
    func loadCountries(completion: @escaping ([Country]) -> Void){
        client.fetchCountries(completion: {
            [weak self] result in
            switch result {
            case .success(let countries):
                guard let self = self else {
                    completion([])
                    return
                }
                self.countries = countries
                completion(self.isFiltering ? self.getFilteredCountries() : countries )
            case .failure(_):
                break
            }
        })
    }
    
    func getFilteredCountries()->[Country]{
        return countries.filter({
            [weak self] country in
            
            var languageFound = true
            var regionFound = true
            
            guard let self = self else {return false}
            
            if languagesFilter.count > 0 {
                languageFound = false
                for language in country.languages ?? [] {
                    if self.languagesFilter[language.iso639_1 ?? ""] != nil {
                        languageFound = true
                        break
                    }
                }
            }
            if regionsFilter.count > 0 {
                regionFound = (self.regionsFilter[country.region ?? ""] != nil)
            }
            
            return regionFound && languageFound
        })
    }
    
    func getLanguages()->[Languages]{
        
        var languagesMap = [String : Languages]()
        
        for country in countries {
            for language in country.languages ?? [] {
                languagesMap.updateValue(language, forKey: language.iso639_1 ?? "")
            }
        }
        return languagesMap.values.sorted(by: {$1.iso639_1 ?? "" > $0.iso639_1 ?? ""})
    }
    
    func getRegions()->[String]{
        
        var regionMap = [String : String]()
        
        for country in countries {
            if let name = country.region, name != "" {
                regionMap.updateValue(name, forKey: name)
            }
        }
        return regionMap.values.sorted(by: {$1 > $0})
    }
    
    func regionFilterActive(key: String)->Bool{
        return regionsFilter.contains(where: {$0.key == key})
    }
    
    func languageFilterActive(key: String)->Bool{
        return languagesFilter.contains(where: {$0.key == key})
    }
    
    func addRegionFilterActive(key: String){
        regionsFilter.updateValue(key, forKey: key)
    }
    
    func addLanguageFilterActive(key: String){
        languagesFilter.updateValue(key, forKey: key)
    }
    
    func removeRegionFilterActive(key: String){
        regionsFilter.removeValue(forKey: key)
    }
    
    func removeLanguageFilterActive(key: String){
        languagesFilter.removeValue(forKey: key)
    }
    
    func resetFilters(){
        languagesFilter.removeAll()
        regionsFilter.removeAll()
    }
}
