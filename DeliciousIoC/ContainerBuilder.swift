//
//  ContainerBuilder.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IContainerBuilderRegistration {
    
    var templateFactory: (IScope -> Any?)! { get }
    var lifetime: ILifetime! { get }
    var interface: Any.Type! { get }
    var implementation: Any.Type! { get }
    
    func implements<I>(interface: I.Type) -> Self
    func hasLifetime(lifetime: ILifetime)
}

public class ContainerBuilderRegistration<T> : IContainerBuilderRegistration {
    
    public private(set) var templateFactory: (IScope -> Any?)!
    
    public var implementation: Any.Type! { get { return T.self } }
    public private(set) var interface: Any.Type!
    
    public private(set) var lifetime: ILifetime!
    
    public init(templateFactory: IScope -> T?) {
        self.templateFactory = templateFactory
        self.implements(T.self)
    }
    
    public func implements<I>(interface: I.Type) -> Self {
        self.interface = I.self
        return self
    }
    
    public func hasLifetime(lifetime: ILifetime) {
        self.lifetime = lifetime
    }
}

public class ContainerBuilder {
    
    private var registrations: Array<IContainerBuilderRegistration> = []
    
    private let defaultLifetimeFactory: Void -> ILifetime
    
    public init(defaultLifetimeFactory: Void -> ILifetime) {
        self.defaultLifetimeFactory = defaultLifetimeFactory
    }
    
    public convenience init() {
        self.init(defaultLifetimeFactory: { TransientLifetime() })
    }
    
    public func register<T>(templateFactory: IScope -> T) -> IContainerBuilderRegistration {
        let registration = ContainerBuilderRegistration(templateFactory: templateFactory)
        registrations.append(registration)
        return registration
    }
    
    public func register<T>(templateFactory: Void -> T) -> IContainerBuilderRegistration {
        return register({ (_: IScope) in
            return templateFactory()
        })
    }
    
    public func build() -> Container {
        let registry = Registry()
        registrations
            .forEach { (registration: IContainerBuilderRegistration) in
                
                var lifetime = registration.lifetime
                if (lifetime == nil) {
                    lifetime = TransientLifetime()
                }
                
                registry.register(
                    registration.interface,
                    lifetime: lifetime,
                    implementation: registration.templateFactory)
            }
        
        let container = Container(registry: registry)
        return container
    }
}