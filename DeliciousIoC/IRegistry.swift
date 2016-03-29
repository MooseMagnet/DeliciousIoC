//
//  IRegistry.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IRegistry {
    func register(interface: Any.Type, lifetime: ILifetime, implementation: IScope -> Any?, tag: String?)
    func getRegistration(forInterface: Any.Type, tag: String?) -> IRegistration?
}