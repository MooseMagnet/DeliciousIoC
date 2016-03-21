//
//  ContainerBuilder.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IContainerBuilderRegistration {
    
    var templateFactory: (Container -> Any)! { get }
    var lifetimeScope: ILifetimeScope! { get }
    var interface: Any.Type! { get }
    var implementation: Any.Type! { get }
    
    func implements<T>(interface: T.Type) -> Self
    func hasLifetimeScope(lifetimeScope: ILifetimeScope)
}

public class ContainerBuilderRegistration<T> : IContainerBuilderRegistration {
    
    public private(set) var templateFactory: (Container -> Any)!
    
    public var implementation: Any.Type! { get { return T.self } }
    public private(set) var interface: Any.Type!
    
    public private(set) var lifetimeScope: ILifetimeScope!
    
    public init(templateFactory: Container -> T) {
        self.templateFactory = templateFactory
        self.implements(T.self)
    }
    
    public func implements<I>(interface: I.Type) -> Self {
        self.interface = I.self
        return self
    }
    
    public func hasLifetimeScope(lifetimeScope: ILifetimeScope) {
        self.lifetimeScope = lifetimeScope
    }
}

public class ContainerBuilder {
    
    private var registrations: Array<IContainerBuilderRegistration> = []
    
    public func register<T>(templateFactory: Container -> T) -> IContainerBuilderRegistration {
        let registration = ContainerBuilderRegistration(templateFactory: templateFactory)
        registrations.append(registration)
        return registration
    }
    
    public func register<T>(templateFactory: Void -> T) -> IContainerBuilderRegistration {
        return register({ (_: Container) in
            return templateFactory()
        })
    }
    
    public func build() -> Container {
        let container = Container()
        registrations
            .map {
                return (String($0.interface), $0)
            }
            .forEach {
                var lifetimeScope = $0.1.lifetimeScope
                if lifetimeScope == nil {
                    lifetimeScope = TransientLifetimeScope()
                }
                let containerRegistration = ContainerRegistration(
                    lifetimeScope: lifetimeScope,
                    templateFactory: $0.1.templateFactory)
                container.register($0.0, registration: containerRegistration)
        }
        return container
    }
}