//
//  ContainerBuilderRegistration.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

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