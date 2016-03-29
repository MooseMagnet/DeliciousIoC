//
//  IResolver.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IResolver {
    func resolve<T>(type: T.Type) -> T?
    func resolve<T>(type: T.Type, tag: String?) -> T?
}