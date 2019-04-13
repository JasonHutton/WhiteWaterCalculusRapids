//
//  Queue.swift
//  Comp8051
//
//  Created by Nathaniel on 2019-04-09.
//  Copyright © 2019 Paul. All rights reserved.
//

struct Queue<T> {
    
    private var list = [T]()
    
    var count: Int {
        get {
            
            return list.count
        }
    }
    
    mutating func enqueue(_ element: T) {
        
        list.append(element)
    }
    
    mutating func dequeue() -> T? {
        
        if !list.isEmpty {
            
            return list.removeFirst()
        } else {
            
            return nil
        }
    }
    
    func peekFront() -> T? {
        
        return list.first
    }
    
    func peekBack() -> T? {
        
        return list.last
    }
    
    mutating func removeAll() {
        
        list.removeAll()
    }
}
