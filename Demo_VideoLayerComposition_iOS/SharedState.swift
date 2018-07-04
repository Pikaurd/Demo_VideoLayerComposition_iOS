//
//  SharedState.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/7/4.
//

import CoreGraphics


class SharedState {
    
    class var `default`: SharedState {
        struct Singleton {
            static let instance = SharedState()
        }
        return Singleton.instance
    }
    
    var pathes: [CGPath] = []
    
}
