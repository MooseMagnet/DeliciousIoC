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
        
        try avoidMultipleDefaultResolutions()
        
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
                        inject(instance, scope: scope)
                        return instance
                    },
                    tag: registration.tag,
                    isDefaultResolution: registration.defaultResolution)
            }
        
        let container = Container(registry: registry)
        return container
    }
    
    private func avoidMultipleDefaultResolutions() throws {
        
        try registrations
            .forEach { (registration) -> () in
                
                let allInterfaceRegistrations = registrations
                    .filter {
                        $0.interface == registration.interface &&
                        $0.tag == registration.tag
                    }
                
                if allInterfaceRegistrations.count == 1 {
                    return
                }
                
                let defaultRegistrations = allInterfaceRegistrations
                    .filter {
                        $0.defaultResolution
                    }
                
                if defaultRegistrations.count > 1 {
                    throw ContainerBuilderError.InterfaceHasMultipleDefaultResolutions(type: registration.interface, tag: registration.tag)
                }
                
            }
    }
}