//
//  VideoComposition.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/6/25.
//

import AVKit


public struct VideoComposition {
    
    let entities: [Entity]
    
    func maxDuration() -> CMTime {
        return entities.reduce(kCMTimeZero) { $1.asset.duration > $0 ? $1.asset.duration : $0 }
    }
    
    func track(entity: Entity) -> AVCompositionTrack {
        
    }
    
    public struct Entity {
        let layer: AVVideoCompositionInstruction
        let asset: AVAsset
    }
}


