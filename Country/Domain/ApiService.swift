//
//  ApiService.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

typealias ApiResponse = (Result<[Country], Error>) -> Void

protocol ApiService {
    func fetchCountries(completion: @escaping ApiResponse)
}
