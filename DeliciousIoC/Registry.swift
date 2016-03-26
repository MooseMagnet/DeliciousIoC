//
//  Registry.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IRegistration {
    var lifetime: ILifetime { get }
    var templateFactory: IScope -> Any? { get }
}

public class Registration : IRegistration {
    
    public private(set) var lifetime: ILifetime
    public private(set) var templateFactory: IScope -> Any?
    
    public init(lifetime: ILifetime, templateFactory: IScope -> Any?, type: Any.Type) {
        self.lifetime = lifetime
        self.templateFactory = templateFactory
    }
}

public protocol IRegistry {
    func register(interface: Any.Type, lifetime: ILifetime, implementation: IScope -> Any?, tag: String?)
    func getRegistration(forInterface: Any.Type, tag: String?) -> IRegistration?
}

public class Registry : IRegistry {
    
    private var registrations: [String: IRegistration] = [:]
    
    public func register(interface: Any.Type, lifetime: ILifetime, implementation: IScope -> Any?, tag: String?) {
        
        guard getRegistration(interface, tag: tag) == nil else {
            fatalError("You can't re-register a thing, you ding-a-ling.")
        }
        
        let registration = Registration(
            lifetime: lifetime,
            templateFactory: implementation,
            type: interface)
        
        let key = "\(String(interface)):~\(tag)"
        
        registrations[key] = registration
    }
    
    public func getRegistration(interface: Any.Type, tag: String?) -> IRegistration? {
        
        let key = "\(String(interface)):~\(tag)"
        
        return registrations[key]
    }
    
}