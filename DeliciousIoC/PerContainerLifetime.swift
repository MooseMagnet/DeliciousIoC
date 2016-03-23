//
//  PerContainerLifetime.swift
//  DeliciousIoC
//
//  Created by Skylark on 23/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import Foundation

public class PerContainerLifetime : ILifetime {
    
    private var singleton: Any?
    
    public func get<T>(factory: IScope -> T, scope: IScope) -> T? {
        if let instance = singleton {
            return (instance as! T)
        }
        
        singleton = factory(scope) as T
        
        if singleton == nil {
            return nil
        }
        
        return (singleton as! T)
    }
}