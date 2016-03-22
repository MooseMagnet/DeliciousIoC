//
//  ScopeTests.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

@testable import DeliciousIoC
import XCTest

class ScopeTests : XCTestCase {
    
    func testInstancePerScope() {
        
        let builder = ContainerBuilder()
        
        builder
            .register( { Foo() } )
            .implements(IFoo.self)
            .withInstancePerScope()
        
    }
    
}