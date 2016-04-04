//
//  InjectTests.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import XCTest
@testable import DeliciousIoC

class InjectTests: XCTestCase {
    
    func testAllInjectPropertiesAreAutomaticallyResolved() {
        let builder = ContainerBuilder()
        
        builder
            .register({ Foo() })
            .implements(IFoo.self)
        
        builder
            .register({ (scope: IScope) in
                Bar(baz: scope.resolve(IBaz.self)!)
            })
            .implements(IBar.self)
        
        builder
            .register({ Baz() })
            .implements(IBaz.self)
        
        builder
            .register({ Qux() })
        
        let container = try! builder.build()
        
        let foo = container.resolve(IFoo.self) as! Foo
        let bar = foo.bar.value as! Bar
        let baz = bar.baz as! Baz
        let qux = baz.qux.value
        
        XCTAssertNotNil(foo)
        XCTAssertNotNil(bar)
        XCTAssertNotNil(baz)
        XCTAssertNotNil(qux)
    }
    
    func testTaggedInjectPropertiesAreResolvedCorrectly() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ ServiceWithTaggedDependency() })
            .implements(IService.self)
        
        let qux = Qux()
        builder
            .register({ qux })
            .hasTag("tag")
        
        let container = try! builder.build()
        
        let service = container.resolve(IService.self) as! ServiceWithTaggedDependency
        
        XCTAssertNotNil(service)
        XCTAssert(service.qux.value === qux)
    }
    
    func testInjectManyPropertiesAreResolvedCorrectly() {
        
        let builder = ContainerBuilder()
        
        builder
            .register({ ServiceWithEnumerableDependencies() })
            .implements(IService.self)
        
        let foo = Foo()
        builder
            .register({ foo })
            .implements(IFoo.self)
        
        builder
            .register({ Bar(baz: Baz()) })
            .implements(IBar.self)
        
        let fu = Fu()
        builder
            .register({ fu })
            .implements(IFoo.self)
        
        let container = try! builder.build()
        
        let service = container.resolve(IService.self) as! ServiceWithEnumerableDependencies
        
        XCTAssertNotNil(service)
        XCTAssert(service.soManyFoos.value[0] as! Foo === foo)
        XCTAssert(service.soManyFoos.value[1] as! Fu === fu)
    }
}
