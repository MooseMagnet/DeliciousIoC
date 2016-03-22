//
//  Container.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public class Container {
    
    private let rootScope: IScope
    
    public init(registry: IRegistry) {
        rootScope = Scope(registry: registry)
    }
    
    public func resolve<T>(type: T.Type) -> T? {
        return rootScope.resolve(type)
    }
}