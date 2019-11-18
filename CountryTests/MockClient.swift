//
//  MockClient.swift
//  CountryTests
//
//  Created by Federico Piccirilli on 17/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation

class MockClient : ApiService {
    
    private let router = Router<CountryApi>(session: MockURLSession())
    
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void){
        router.request(CountryApi.all(()) , completion: {
            response in
            switch response {
            case .success(let data):
                    do {
                    let decoder = JSONDecoder()
                    let countryList = try decoder.decode([Country].self, from: data)
                    completion(.success(countryList))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }})
    }
}
