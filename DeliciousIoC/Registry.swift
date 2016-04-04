//
//  Registry.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public class Registry : IRegistry {
    
    private var registrations: [String: ArrayReference<IRegistration>] = [:]
    
    public func register(interface: Any.Type, lifetime: ILifetime, implementation: IScope -> Any?, tag: String?, isDefaultResolution: Bool) {
        
        let defaultResolutionRegistration = getRegistrationsIfAny(interface, tag: tag)?
            .filter {
                $0.defaultResolution
            }
            .first
        
        if isDefaultResolution && defaultResolutionRegistration != nil {
            fatalError("There's already a default resolution.")
        }
        
        let registration = Registration(
            lifetime: lifetime,
            templateFactory: implementation,
            type: interface,
            isDefaultResolution: isDefaultResolution)
        
        let key = "\(String(interface)):~\(tag)"
        
        if registrations[key] == nil {
            registrations[key] = ArrayReference(array: [])
        }
        
        registrations[key]?.append(registration)
    }
    
    public func getDefaultRegistration(interface: Any.Type, tag: String?) -> IRegistration? {
        
        guard let registrations = getRegistrationsIfAny(interface, tag: tag) else {
            return nil
        }
        
        if registrations.count == 1 {
            return registrations[0]
        }
        
        return registrations
            .filter {
                $0.defaultResolution
            }
            .first
    }
    
    public func getRegistrations(interface: Any.Type, tag: String?) -> Array<IRegistration> {
        return getRegistrationsIfAny(interface, tag: tag) ?? []
    }
    
    private func getRegistrationsIfAny(type: Any.Type, tag: String?) -> Array<IRegistration>? {
        let key = "\(String(type)):~\(tag)"
        return registrations[key]?.array
    }
}