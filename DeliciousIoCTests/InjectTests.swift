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
        
        let container = builder.build()
        
        let foo = container.resolve(IFoo.self) as! Foo
        let bar = foo.bar.value as! Bar
        let baz = bar.baz as! Baz
        let qux = baz.qux.value
        
        XCTAssertNotNil(foo)
        XCTAssertNotNil(bar)
        XCTAssertNotNil(baz)
        XCTAssertNotNil(qux)
    }
    
}
