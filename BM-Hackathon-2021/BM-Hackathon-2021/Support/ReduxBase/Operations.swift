//
//  Operations.swift
//  BM-Hackathon-2021
//
//  Created by Andrii Halushka on 23.04.2021.
//

import Foundation

public func | <T>(_ object: T, block: (inout T) -> Void) -> T {
    modified(object, block: block)
}

func modified<T>(_ object: T, block: (inout T) -> Void) -> T {
    var newObject = object
    block(&newObject)
    return newObject
}
