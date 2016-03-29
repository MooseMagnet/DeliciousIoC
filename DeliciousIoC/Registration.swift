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
    
    public init(lifetime: ILifetime, templateFactory: IScope -> Any?, type: Any.Type) {
        self.lifetime = lifetime
        self.templateFactory = templateFactory
    }
}