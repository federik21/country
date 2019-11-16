//
//  NetworkManager.swift
//  NetworkLayer
//
//  Created by Malcolm Kumwenda on 2018/03/11.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

enum NetworkResponse:String, Error {
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

struct NetworkManager {
    static let environment : NetworkEnvironment = .production
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Int, Error>{
        switch response.statusCode {
        case 200...299: return .success(response.statusCode)
        case 401...500: return .failure((NetworkResponse.authenticationError))
        case 501...599: return .failure((NetworkResponse.badRequest))
        case 600: return .failure((NetworkResponse.outdated))
        default: return .failure((NetworkResponse.failed))
        }
    }
}
