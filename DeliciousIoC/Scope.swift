//
//  Scope.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IResolver {
    func resolve<T>(type: T.Type) -> T?
    func resolve<T>(type: T.Type, tag: String?) -> T?
}

public protocol IScope : IResolver {
    var parentScope: IScope? { get }
    func createScope() -> IScope
    
    func trackInstance(instance: Any)
    func getTrackedInstance<T>(type: T.Type) -> T?
}

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
        guard let registration = registry.getRegistration(type, tag: tag) else {
            return nil
        }

        let lifetime = registration.lifetime
        let factory = registration.templateFactory
        
        guard let instance = lifetime.get(factory, scope: self) as? T else {
            return nil
        }
        
        return instance
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