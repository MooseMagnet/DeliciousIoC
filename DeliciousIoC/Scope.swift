//
//  Scope.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public class Scope : IScope {
    
    public private(set) var parentScope: IScope?
    private var registry: IRegistry
    
    private var trackedInstances: Array<Any> = []
    
    public init(parentScope: IScope?, registry: IRegistry) {
        self.parentScope = parentScope
        self.registry = registry
    }
    
    public convenience init(registry: IRegistry) {
        self.init(parentScope: nil, registry: registry)
    }
    
    public func resolve<T>(type: T.Type) -> T? {
        return resolve(type, tag: nil)
    }
    
    public func resolve<T>(type: T.Type, tag: String?) -> T? {
        
        guard let registration = registry.getDefaultRegistration(type, tag: tag) else {
            return nil
        }

        let lifetime = registration.lifetime
        let factory = registration.templateFactory
        
        guard let instance = lifetime.get(factory, scope: self) as? T else {
            return nil
        }
        
        return instance
    }
    
    public func resolveAll<T>(type: T.Type) -> Array<T> {
        return resolveAll(type, tag: nil)
    }
    
    public func resolveAll<T>(type: T.Type, tag: String?) -> Array<T> {
        
        let registrations = registry.getRegistrations(type, tag: tag)
        
        if registrations.count == 0 {
            return []
        }
        
        return registrations
            .map {
                $0.lifetime.get($0.templateFactory, scope: self) as! T
            }
    }
    
    public func trackInstance(instance: Any) {
        trackedInstances.append(instance)
    }
    
    public func getTrackedInstance<T>(type: T.Type) -> T? {
        return trackedInstances.filter { $0 is T }.first as? T
    }
    
    public func createScope() -> IScope {
        return Scope(parentScope: self, registry: registry)
    }
}