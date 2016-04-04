//
//  ArrayReference.swift
//  DeliciousIoC
//
//  Created by Skylark on 3/04/2016.
//  Copyright © 2016 DevSword. All rights reserved.
//

class ArrayReference<T: Any> {
    
    private var _array: Array<T>
    
    var array: Array<T> {
        get {
            return _array
        }
    }
    
    init(array: Array<T>) {
        _array = array
    }
    
    func append(element: T) {
        _array.append(element)
    }
}