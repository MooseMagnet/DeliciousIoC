//
//  TransientLifetime.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

import Foundation

public class TransientLifetime : ILifetime {
    public func get<T>(factory: IScope -> T, scope: IScope) -> T? {
        return factory(scope)
    }
}