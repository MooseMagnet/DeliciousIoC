//
//  IRegistration.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IRegistration {
    var lifetime: ILifetime { get }
    var templateFactory: IScope -> Any? { get }
    var defaultResolution: Bool { get }
}