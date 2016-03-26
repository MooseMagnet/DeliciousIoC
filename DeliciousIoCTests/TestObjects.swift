//
//  TestObjects.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import DeliciousIoC

protocol IService {
    func please() -> Bool
}

protocol IFoo {
    func foo() -> Int
}

protocol IBar {
    func bar()
}

protocol IBaz {
    func baz() -> String
}

class Service : IService {
    func please() -> Bool {
        return true
    }
}

class Foo : IFoo{
    
    var bar = Inject<IBar>()
    
    func foo() -> Int {
        bar.value.bar()
        return 100
    }
}

class Fu : IFoo {
    func foo() -> Int {
        return 999
    }
}

class Bar : IBar {
    
    let baz: IBaz
    
    init(baz: IBaz) {
        self.baz = baz
    }
    
    func bar() {
        print(baz.baz())
    }
}

class Baz : IBaz {
    
    var qux = Inject<Qux>()
    
    func baz() -> String {
        return "Baz and also \(qux.value.qux)"
    }
}

class Qux {
    let qux = "Qux"
}
