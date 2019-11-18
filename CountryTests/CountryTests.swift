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
            assert(self.viewModel.languagesFilterMap.count == 111 )
            assert(self.viewModel.regionsFilterMap.count == 7 )

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
        viewModel.languagesFilterMap.updateValue(true, forKey: language)
        viewModel.isFiltering = true
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            for country in countries{
                assert(country.languages?.first(where: {$0.iso639_1 == language}) != nil)
            }
            assert(self.viewModel.languagesFilterMap.count == 111 )
            assert(self.viewModel.regionsFilterMap.count == 7 )

        })
    }
    
    func testSingleRegionFilter() {
        viewModel.loadCountries(completion: {
            [unowned self] countries in
            self.checkSingleRegionFilter()
        })
    }
    
    func checkSingleRegionFilter(){
        let region = "Europe"
        viewModel.regionsFilterMap.updateValue(true, forKey: region)
        viewModel.isFiltering = true
        viewModel.loadCountries(completion: {
            countries in
            assert(countries.count < 250)
            for country in countries{
                assert(country.region == region)
            }
            assert(self.viewModel.languagesFilterMap.count == 111 )
            assert(self.viewModel.regionsFilterMap.count == 7 )

        })
    }

    
}
