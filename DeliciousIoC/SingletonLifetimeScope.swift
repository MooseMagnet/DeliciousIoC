//
//  SingletonLifetimeScope.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public class SingletonLifetimeScope : ILifetimeScope {
    
    private var singleton: Any!
    
    public func resolve<T>(factory: Void -> T) -> T {
        if (singleton == nil) {
            singleton = factory()
        }
        return singleton as! T
    }
}