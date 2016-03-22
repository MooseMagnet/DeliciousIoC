//
//  Scope.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IResolver {
    func resolve<T>(type: T.Type) -> T?
}

public protocol IScope : IResolver {
    var parentScope: IScope? { get }
    func createScope() -> IScope
}

public class Scope : IScope {
    
    public private(set) var parentScope: IScope?
    private var registry: IRegistry
    
    private var trackedInstances: Array<Any> = []
    
    public init(parentScope: IScope?, registry: IRegistry) {
        self.parentScope = parentScope
        self.registry = registry
    }
    
    deinit {
        // TODO: when deactivating the scope, we should let
        // instances know so they can do any clean-up...
        // or maybe we just let their deinit's do it. I dunno.
        trackedInstances.removeAll()
    }
    
    public convenience init(registry: IRegistry) {
        self.init(parentScope: nil, registry: registry)
    }
    
    public func resolve<T>(type: T.Type) -> T? {
        guard let registration = registry.getRegistration(type) else {
            return nil
        }

        let lifetime = registration.lifetime
        let factory = registration.templateFactory
        
        guard let instance = lifetime.get(factory, scope: self) as? T else {
            return nil
        }
        
        trackInstance(instance)
        
        return instance
    }
    
    private func trackInstance(instance: Any) {
        trackedInstances.append(instance)
    }
    
    public func createScope() -> IScope {
        return Scope(parentScope: self, registry: registry)
    }
}