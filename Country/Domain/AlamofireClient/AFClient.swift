//
//  AFClient.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation
import Alamofire

//Fast implentation with the Alamofire framework

class AFClient : ApiService {
    func fetchCountries(completion: @escaping (Result<[Country], Error>) -> Void){
        AF.request("https://restcountries.eu/rest/v2/all", encoding: JSONEncoding.default)
        .responseJSON{
            response in
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let countryList = try decoder.decode([Country].self, from: data)
                completion(.success(countryList))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
