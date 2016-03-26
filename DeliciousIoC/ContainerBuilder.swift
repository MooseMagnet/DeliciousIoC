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
    var tag: String? { get }
    
    func implements<I>(interface: I.Type) -> Self
    func hasLifetime(lifetime: ILifetime) -> Self
    func hasTag(tag: String) -> Self
}

public class ContainerBuilderRegistration<T> : IContainerBuilderRegistration {
    
    private var containerBuilder: ContainerBuilder
    
    public private(set) var templateFactory: (IScope -> Any?)!
    
    public var implementation: Any.Type! { get { return T.self } }
    public private(set) var interface: Any.Type!
    
    public private(set) var tag: String?
    
    public private(set) var lifetime: ILifetime!
    
    public init(templateFactory: IScope -> T?, containerBuilder: ContainerBuilder) {
        self.templateFactory = templateFactory
        self.containerBuilder = containerBuilder
        self.implements(T.self)
    }
    
    public func implements<I>(interface: I.Type) -> Self {
        self.interface = I.self
        return self
    }
    
    public func hasLifetime(lifetime: ILifetime) -> Self {
        self.lifetime = lifetime
        return self
    }
    
    public func hasTag(tag: String) -> Self {
        self.tag = tag
        return self
    }
}

public enum ContainerBuilderError : ErrorType {
    case DuplicateRegistration(type: Any.Type, tag: String?)
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
        let registration = ContainerBuilderRegistration(
            templateFactory: templateFactory,
            containerBuilder: self)
        registrations.append(registration)
        return registration
    }
    
    public func register<T>(templateFactory: Void -> T) -> IContainerBuilderRegistration {
        return register({ (_: IScope) in
            return templateFactory()
        })
    }
    
    public func build() throws -> Container {
        
        try avoidDuplicates()
        
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
                    implementation: { (scope: IScope) in
                        // TODO: Should this be here? I HATE YOU.
                        guard let instance = registration.templateFactory(scope) else {
                            return nil
                        }
                        inject(instance, scope: scope, tag: registration.tag)
                        return instance
                    },
                    tag: registration.tag)
            }
        
        let container = Container(registry: registry)
        return container
    }
    
    private func avoidDuplicates() throws {
        var group: [String:IContainerBuilderRegistration] = [:]
        
        try registrations
            .forEach { (registration) -> () in
                let key = "\(String(registration.interface)):~\(registration.tag)"
                guard group[key] == nil else {
                    throw ContainerBuilderError.DuplicateRegistration(
                        type: registration.interface,
                        tag: registration.tag)
                }
                group[key] = registration
            }
    }
}