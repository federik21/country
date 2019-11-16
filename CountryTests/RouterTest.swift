//
//  NativeClientTest.swift
//  CountryTests
//
//  Created by Federico Piccirilli on 16/11/2019.
//  Copyright © 2019 Federico Piccirilli. All rights reserved.
//

import XCTest

class RouterTest: XCTestCase {
    
    var router :Router<CountryApi>!
    let session = MockURLSession()
        
    override func setUp() {
        super.setUp()
        router = Router(session: session)
    }
    
    func test_get_request_all_countries() {
        session.nextError = nil
        session.nextData = Data()
        router.request(CountryApi.all(()), completion: {
            result in
            switch result{
            case .success(_):
                assert(true)

            case .failure(_):
                assert(false)
            }
        })
    }
    
    override func tearDown() {
        super.tearDown()
    }
}
