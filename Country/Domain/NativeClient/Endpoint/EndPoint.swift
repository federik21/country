//
//  NativeClient.swift
//  Country
//
//  Created by Federico Piccirilli on 13/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation


enum NetworkEnvironment {
    case qa
    case production
    case staging
}

public enum CountryApi {
    case all(Void)
}

extension CountryApi: EndPointType {
    
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://restcountries.eu/rest/"
        case .qa: return "https://restcountries.eu/rest/"
        case .staging: return "https://restcountries.eu/rest/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .all:
            return "v2/all"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
