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
        return resolve(type, tag: nil)
    }
    
    public func resolve<T>(type: T.Type, tag: String?) -> T? {
        return rootScope.resolve(type, tag: tag)
    }
    
    public func resolveAll<T>(type: T.Type) -> Array<T> {
        return resolveAll(type, tag: nil)
    }
    
    public func resolveAll<T>(type: T.Type, tag: String?) -> Array<T> {
        return rootScope.resolveAll(type, tag: tag)
    }
    
    public func createScope() -> IScope {
        return rootScope.createScope()
    }
}