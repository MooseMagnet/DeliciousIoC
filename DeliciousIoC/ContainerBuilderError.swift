//
//  ContainerBuilderError.swift
//  DeliciousIoC
//
//  Created by Skylark on 30/03/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

public enum ContainerBuilderError : ErrorType {
    case InterfaceHasMultipleDefaultResolutions(type: Any.Type, tag: String?)
}