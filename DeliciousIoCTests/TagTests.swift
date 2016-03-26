//
//  TagTests.swift
//  DeliciousIoC
//
//  Created by Skylark on 26/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

@testable import DeliciousIoC
import XCTest

class TagTests : XCTestCase {
    
    func testTaggedInstances() {
        
        let builder = ContainerBuilder()
        
        let instance = Foo()
        
        builder
            .register({ instance })
            .implements(IFoo.self)
            .hasLifetime(PerContainerLifetime())
            .hasTag("tag")
        
        let container = try! builder.build()
        
        let unresolved = container.resolve(IFoo.self)
        XCTAssert(unresolved == nil)
        
        let resolvedWithTag = container.resolve(IFoo.self, tag: "tag") as! Foo
        XCTAssert(resolvedWithTag === instance)
    }
}