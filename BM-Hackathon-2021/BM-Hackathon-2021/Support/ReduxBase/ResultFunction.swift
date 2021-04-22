//
//  ResultFunction.swift
//  Walking
//
//  Created by Vitalii Malakhovskyi on 8/29/18.
//  Copyright © 2018 Betterme. All rights reserved.
//

import Foundation

/// This is simple apply like function.
/// It main goal to avoid code like this:
///
/// ```
/// let x = { ... }()
/// ```
///
/// Instead you can write:
/// ```
/// let x = result { ... }
/// ```
public func result<Result>(from block: () -> Result) -> Result {
    return block()
}
