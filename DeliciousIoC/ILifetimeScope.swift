//
//  ILifetimeScope.swift
//  DeliciousIoC
//
//  Created by Skylark on 21/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol ILifetimeScope {
    func resolve<T>(factory: Void -> T) -> T
}