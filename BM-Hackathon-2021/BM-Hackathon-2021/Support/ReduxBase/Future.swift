//
//  Future.swift
//  BMAbstractions
//
//  Created by Serhii Onopriienko on 8/22/19.
//

import Foundation

public class Future<T> {
    fileprivate let queue = DispatchQueue(label: "private future queue")
    fileprivate var value: T?
    fileprivate var callbacks: [(T) -> ()] = []
    
    public func onComplete(perform block: @escaping (T) -> ()) {
        queue.async {
            if let value = self.value {
                block(value)
            } else {
                self.callbacks.append(block)
            }
        }
    }
}

public final class Promise<T>: Future<T> {
    public init(value: T? = nil) {
        super.init()
        self.value = value
    }
    
    public init(work: (@escaping (T) -> ()) -> ()) {
        super.init()
        work { value in
            self.queue.async {
                self.value = value
                self.callbacks.forEach { $0(value) }
                self.callbacks = []
            }
        }
    }
}

public extension Future {
    func then<U>(with thennable: @escaping (T) -> Future<U>) -> Future<U> {
        return Promise { completion in
            onComplete { value in
                thennable(value).onComplete(perform: completion)
            }
        }
    }
}

public extension Future {
    func map<U>(transform: @escaping (T) -> U) -> Future<U> {
        return then { value in
            return Promise(value: transform(value))
        }
    }
}
