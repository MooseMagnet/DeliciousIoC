//
//  ContainerBuilderTests.swift
//  DeliciousIoC
//
//  Created by Skylark on 26/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

@testable import DeliciousIoC
import XCTest

class ContainerBuilderTests : XCTestCase {
    
    func testFailToCreateContainerWithDuplicateTaggedRegistrations() {
        let builder = ContainerBuilder()
        
        let register = {
            builder
                .register({ Foo() })
                .implements(IFoo.self)
                .hasLifetime(PerContainerLifetime())
                .hasTag("tag")
        }
        register()
        register()
        
        do {
            _ = try builder.build()
        } catch ContainerBuilderError.DuplicateRegistration(type: let type, tag: let tag) {
            XCTAssert(type == IFoo.self)
            XCTAssert(tag == "tag")
            return
        } catch {
            XCTFail()
        }
        
        XCTFail()
    }
    
}