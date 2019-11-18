//
//  RouterMock.swift
//  CountryTests
//
//  Created by Federico Piccirilli on 16/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import Foundation

class MockError : Error {
    let message = "error"
}

class MockURLSession :URLSessionProtocol{
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let testBundle = Bundle(for: type(of: self))
        guard let path = testBundle.url(forResource: "allCountryResponse", withExtension: "json") else { fatalError() }
        do{
            nextData = try Data(contentsOf: path, options: .mappedIfSafe)}
        catch {
        nextError = MockError()
        }
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
    private func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
}


class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}
