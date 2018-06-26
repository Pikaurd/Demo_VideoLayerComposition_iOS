//
//  List+Extension.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/6/26.
//

import Foundation


extension Array {
    func apply(_ fn: (Element) -> ()) -> () {
        for x: Element in self { fn(x) }
    }
    
    func applyWithIndex(_ fn: (Int, Element) -> ()) -> () {
        for (i, x) in self.enumerated() {
            fn(i, x)
        }
    }
    
    func all(_ fn: (Element) -> Bool) -> Bool {
        for x: Element in self {
            if !fn(x) {
                return false
            }
        }
        return true
    }
    
    func exist(_ fn: (Element) -> Bool) -> Bool {
        for x: Element in self {
            if fn(x) {
                return true
            }
        }
        return false
    }
    
    func window(start: Int, step: Int) -> [Element] {
        guard step > 0 else { return [] }
        assert(start >= 0 && start < count && step <= count)
        
        var xs: [Element] = []
        var i = start
        if start + step <= count {
            while i < start + step {
                xs.append(self[i])
                i += 1
            }
        }
        else {
            while i < count {
                xs.append(self[i])
                i += 1
            }
            i = 0
            while i < step - (count - start) {
                xs.append(self[i])
                i += 1
            }
        }
        
        return xs
    }
    
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
}
