//
//  Inject.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//


public protocol InjectWrapper {
    func setValue(scope: IScope, tag: String?)
}

public class Inject<T> : InjectWrapper {
    
    public private(set) var value: T!
    
    // NOTE: Swift compiler is broken
    public init() {}
    
    public func setValue(scope: IScope, tag: String?) {
        value = scope.resolve(T.self, tag: tag)
    }
}

internal func inject(instance: Any, scope: IScope, tag: String?) {
    Mirror(reflecting: instance)
        .children
        .map { $0.value as? InjectWrapper }
        .filter { $0 != nil }
        .forEach {
            $0!.setValue(scope, tag: tag)
    }
}