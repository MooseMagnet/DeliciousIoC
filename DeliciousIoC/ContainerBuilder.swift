//
//  ContainerBuilder.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

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