//
//  Dispatcher.swift
//  Walking
//
//  Created by Vitalii Malakhovskyi on 8/27/18.
//  Copyright © 2018 Betterme. All rights reserved.
//

import Foundation

/// This protocol is the basic component of interactive action creators
public protocol Dispatcher {
    func dispatch(action: Action)
}

/// It is possible to add some extensions which will implement
/// compatibility with differnt parts of the system
public extension Dispatcher {
    func dispatch(future: Future<Action>) {
        _ = future.map(transform: dispatch)
    }
    
    func dispatch(command: CommandWith<Dispatcher>) {
        command.perform(with: self)
    }
}
