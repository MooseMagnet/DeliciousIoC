//
//  EnumerablInjectTests.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

@testable import DeliciousIoC
import XCTest

class EnumerableInjectTests : XCTestCase {
    
    func testResolveAllResolvesAllRegisteredResolutions() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ Foo() })
            .implements(IFoo.self)
            .isDefaultResolution()

        builder
            .register({ Fu() })
            .implements(IFoo.self)
        
        builder
            .register({ Bar(baz: Baz()) })
            .implements(IBar.self)
        
        let container = try! builder.build()
        
        let justFoo = container.resolve(IFoo.self)!
        
        XCTAssert(justFoo is Foo)
        
        let allTheIFoos = container.resolveAll(IFoo.self)
        
        XCTAssert(allTheIFoos[0] is Foo)
        XCTAssert(allTheIFoos[1] is Fu)
    }
    
    func testDefaultResolutionIsUnnecessary() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ Foo() })
            .implements(IFoo.self)
        
        builder
            .register({ Fu() })
            .implements(IFoo.self)
        
        builder
            .register({ Bar(baz: Baz()) })
            .implements(IBar.self)
        
        let container = try! builder.build()
        
        let justFoo = container.resolve(IFoo.self)
        
        XCTAssertNil(justFoo)
        
        let allTheIFoos = container.resolveAll(IFoo.self)
        
        XCTAssert(allTheIFoos[0] is Foo)
        XCTAssert(allTheIFoos[1] is Fu)
    }
}