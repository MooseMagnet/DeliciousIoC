//
//  Inject.swift
//  DeliciousIoC
//
//  Created by Skylark on 22/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//


public protocol InjectWrapper {
    func setValue(scope: IScope)
}

public class Inject<T> : InjectWrapper {
    
    public private(set) var value: T!
    public private(set) var tag: String?
    
    public init() {
        self.tag = nil
    }
    
    public init(tag: String) {
        self.tag = tag
    }
    
    public func setValue(scope: IScope) {
        value = scope.resolve(T.self, tag: tag)
    }
}

public class InjectMany<T> : InjectWrapper {
    
    public private(set) var value: Array<T>!
    public private(set) var tag: String?
    
    public init() {
        self.tag = nil
    }
    
    public init(tag: String) {
        self.tag = tag
    }
    
    public func setValue(scope: IScope) {
        value = scope.resolveAll(T.self, tag: tag)
    }
}

internal func inject(instance: Any, scope: IScope) {
    Mirror(reflecting: instance)
        .children
        .map { $0.value as? InjectWrapper }
        .filter { $0 != nil }
        .forEach {
            $0!.setValue(scope)
    }
}