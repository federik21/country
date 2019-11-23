//
//  CountryTests.swift
//  CountryTests
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import XCTest
@testable import Country

class CountryTests: XCTestCase {
    
    var viewModel : CountryViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CountryViewModel(service: MockClient())
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetUnfilteredList() {
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count == 250)
        })
    }
    
    func testSingleLanguageFilter() {
        viewModel.loadCountries(completion: {
            [unowned self] countries in
            self.checkSingleLanguageFilter()
        })
    }
    
    func checkSingleLanguageFilter(){
        let language = "en"
        viewModel.addLanguageFilterActive(key: language)
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            assert(countries.count > 0)
            for country in countries{
                assert(country.languages?.first(where: {$0.iso639_1 == language}) != nil)
            }

        })
    }
    
    func testSingleRegionFilter() {
        viewModel.loadCountries(completion: {
            [unowned self] countries in
            self.singleRegionFilter()
        })
    }
    
    func singleRegionFilter(){
        let region = "Europe"
        viewModel.addRegionFilterActive(key: region)
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            assert(countries.count > 0)
            for country in countries{
                assert(country.region == region)
            }

        })
    }

    func testMultipleRegionFilter() {
        viewModel.loadCountries(completion: {
            [unowned self] countries in
            self.checkMultipleRegionFilter()
        })
    }
    
    func checkMultipleRegionFilter(){
        let region1 = "Europe"
        let region2 = "Americas"
        viewModel.addRegionFilterActive(key: region1)
        viewModel.addRegionFilterActive(key: region2)
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            for country in countries{
                assert(country.region == region1 || country.region == region2)
            }

        })
    }
    
    
    func testCrossedRegionLanguageFilter() {
        viewModel.loadCountries(completion: {
            [unowned self] countries in
            self.checkCrossedRegionLanguageFilter()
        })
    }
    
    func checkCrossedRegionLanguageFilter(){
        let region1 = "Europe"
        let region2 = "Africa"
        viewModel.addRegionFilterActive(key: region1)
        viewModel.addRegionFilterActive(key: region2)
        
        let language1 = "fr"
        let language2 = "it"
        viewModel.addLanguageFilterActive(key: language1)
        viewModel.addLanguageFilterActive(key: language2)

        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            for country in countries{
                assert(country.region == region1 || country.region == region2)
                assert(country.languages?.first(where: {$0.iso639_1 == language1 || $0.iso639_1 == language2}) != nil)
                assert(country.name == "France"
                    || country.name == "Marocco" //Africa
                    || country.name != "Canada" //Not in region filter for region
                    || country.name != "Germany" //Not in region filter for language
                    || country.name != "Japan" //Not in region filter for all
                )
            }

        })
    }
    
}
