//
//  SingletonTests.swift
//  DeliciousIoCTests
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import XCTest
@testable import DeliciousIoC

class SingletonTests: XCTestCase {
    
    func testAreSameObjectEverytime() {
        let builder = ContainerBuilder()
        
        builder
            .register({ Service() })
            .implements(IService.self)
            .hasLifetimeScope(SingletonLifetimeScope())
        
        let container = builder.build()
        
        let service1 = container.resolve(IService.self) as! Service
        let service2 = container.resolve(IService.self) as! Service
        
        XCTAssert(service1 === service2)
    }
    
}
