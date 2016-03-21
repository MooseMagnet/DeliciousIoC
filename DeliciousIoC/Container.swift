//
//  Container.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IContainerRegistration {
    var lifetimeScope: ILifetimeScope { get }
    var templateFactory: Container -> Any { get }
}

public class ContainerRegistration : IContainerRegistration {
    
    public private(set) var lifetimeScope: ILifetimeScope
    public private(set) var templateFactory: Container -> Any
    
    public init(lifetimeScope: ILifetimeScope, templateFactory: Container -> Any) {
        self.lifetimeScope = lifetimeScope
        self.templateFactory = templateFactory
    }
}

public class Container {
    
    private var registrations: [String: IContainerRegistration] = [:]
    
    internal func register(key: String, registration: IContainerRegistration) {
        registrations[key] = registration
    }
    
    public func resolve<T>(interface: T.Type) -> T {
        let key = String(T)
        let registration = registrations[key]!
        let factory: Void -> T = {
            let instance = registration.templateFactory(self) as! T
            self.inject(instance)
            return instance
        }
        return registration.lifetimeScope.resolve(factory)
    }
    
    private func inject(instance: Any) {
        Mirror(reflecting: instance)
            .children
            .map { $0.value as? InjectWrapper }
            .filter { $0 != nil }
            .forEach {
                $0!.resolve(self)
            }
    }
}

public protocol InjectWrapper {
    func resolve(container: Container)
}

public class Inject<T> : InjectWrapper {
    
    public private(set) var value: T!
    
    // NOTE: Swift compiler is broken
    public init() {}
    
    public func resolve(container: Container) {
        value = container.resolve(T)
    }
}