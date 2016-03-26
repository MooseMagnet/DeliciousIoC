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
    
    func testMultipleTaggedResolutions() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ Fu() })
            .implements(IFoo.self)
            .hasTag("Fu")

        builder
            .register({ Foo() })
            .implements(IFoo.self)
        
        let container = try! builder.build()
        
        guard let _ = container.resolve(IFoo.self, tag: "Fu") as? Fu else {
            XCTFail()
            return
        }
        guard let _ = container.resolve(IFoo.self) as? Foo else {
            XCTFail()
            return
        }
    }
}