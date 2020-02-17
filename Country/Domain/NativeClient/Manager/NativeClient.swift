//
//  NativeClient.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation

//  This client is based on the work of by Malcolm Kumwenda. I've migrated all the responses to the newer Result type introduced in Swift 5.0, and modified Router class to have an injectable session for testing purposes.

class NativeClient : ApiService {
    
    static var environment :NetworkEnvironment = NetworkEnvironment.production
    private let router = Router<CountryApi>(session: URLSession.shared)
    
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
    
    func some(country :String, completion: @escaping (Result<[Country], Error>) -> Void){
        router.request(CountryApi.some(country: country) , completion: {
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
