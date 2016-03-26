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
            .register({ Foo() })
            .implements(IFoo.self)
            .hasLifetime(PerScopeLifetime())
        
        let container = try! builder.build()
        
        let scope1 = container.createScope()
        let scope2 = container.createScope()
        
        let scope1InstanceA = scope1.resolve(IFoo.self) as! Foo
        let scope2InstanceA = scope2.resolve(IFoo.self) as! Foo
        
        let scope1InstanceB = scope1.resolve(IFoo.self) as! Foo
        let scope2InstanceB = scope2.resolve(IFoo.self) as! Foo
        
        XCTAssert(scope1InstanceA === scope1InstanceB)
        XCTAssert(scope2InstanceA === scope2InstanceB)
        
        XCTAssert(scope1InstanceA !== scope2InstanceA)
    }
    
    func testInstancePerContainer() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ Foo() })
            .implements(IFoo.self)
            .hasLifetime(PerContainerLifetime())
        
        let container = try! builder.build()
        
        let scope1 = container.createScope()
        let scope2 = container.createScope()
        
        let containerInstance = container.resolve(IFoo.self) as! Foo
        let scope1Instance = scope1.resolve(IFoo.self) as! Foo
        let scope2Instance = scope2.resolve(IFoo.self) as! Foo
        
        XCTAssert(containerInstance === scope1Instance)
        XCTAssert(containerInstance === scope2Instance)
    }
    
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
    
    func testFailToCreateDuplicateTaggedRegistrations() {
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