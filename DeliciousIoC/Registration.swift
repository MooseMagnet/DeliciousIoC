//
//  Registration.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public class Registration : IRegistration {
    
    public private(set) var lifetime: ILifetime
    public private(set) var templateFactory: IScope -> Any?
    public private(set) var defaultResolution: Bool
    
    public init(lifetime: ILifetime, templateFactory: IScope -> Any?, type: Any.Type, isDefaultResolution: Bool) {
        self.lifetime = lifetime
        self.templateFactory = templateFactory
        self.defaultResolution = isDefaultResolution
    }
}