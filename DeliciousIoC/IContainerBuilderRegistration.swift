//
//  IContainerBuilderRegistration.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public protocol IContainerBuilderRegistration {
    
    var templateFactory: (IScope -> Any?)! { get }
    var lifetime: ILifetime! { get }
    var interface: Any.Type! { get }
    var implementation: Any.Type! { get }
    var tag: String? { get }
    var defaultResolution: Bool { get }
    
    func implements<I>(interface: I.Type) -> Self
    func hasLifetime(lifetime: ILifetime) -> Self
    func hasTag(tag: String) -> Self
    func isDefaultResolution() -> Self
}