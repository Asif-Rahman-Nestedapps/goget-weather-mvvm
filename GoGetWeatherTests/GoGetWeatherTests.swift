//
//  GoGetWeatherTests.swift
//  GoGetWeatherTests
//
//  Created by Akond Asif Ur Rahman on 1/11/19.
//  Copyright © 2019 Akond Asif Ur Rahman. All rights reserved.
//

import XCTest
@testable import GoGetWeather

class GoGetWeatherTests: XCTestCase {
    var gogetWeatherTest : ViewController!
    var sessionUnderTest : URLSession!

    override func setUp() {
        super.setUp()
         gogetWeatherTest = ViewController()

        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let guess = UIColor.init(red:126/255 , green: 135/255, blue: 150/255, alpha: 1.0)
        let color = gogetWeatherTest.setBgColorAccordingToWeather(weatherStatus:"cloud")
        XCTAssertEqual(color, guess, "Test Succedded")

    }
    
    func testValidCallToAPIStatusCode200() {
        // given
        let url = URL(string: "https://api.darksky.net/forecast/d5b68f05aca3b7fa8cde5b2d473ed986/33.8650,151.2094")
        // 1
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    // 2
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        // 3
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
