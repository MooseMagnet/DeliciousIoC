//
//  IScope.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IScope : IResolver {
    var parentScope: IScope? { get }
    func createScope() -> IScope
    
    func trackInstance(instance: Any)
    func getTrackedInstance<T>(type: T.Type) -> T?
}