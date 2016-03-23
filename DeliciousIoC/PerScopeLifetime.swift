//
//  PerScopeLifetime.swift
//  DeliciousIoC
//
//  Created by Skylark on 23/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import Foundation

public class PerScopeLifetime : ILifetime {
    
    public func get<T>(factory: IScope -> T, scope: IScope) -> T? {
        
        if let trackedInstance = scope.getTrackedInstance(T.self) {
            return trackedInstance
        }
        
        let newInstance = factory(scope)
        
        scope.trackInstance(newInstance)
        
        return newInstance
    }
    
}