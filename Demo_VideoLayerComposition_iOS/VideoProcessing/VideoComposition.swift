//
//  VideoComposition.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/6/25.
//

import AVKit


public struct VideoComposition {
    
    let entities: [Entity]
    let renderSize: CGSize
    private var maxDuration: CMTime
    
    init(entities: [Entity], renderSize: CGSize) {
        self.entities = entities
        self.renderSize = renderSize
        self.maxDuration = VideoComposition.maxDuration(entities: entities)
    }
    
    func export(to destination: URL) -> () {
        let mixComposition = AVMutableComposition()
        let tracks = entities.map { $0.videoTrack(composition: mixComposition, duration: self.maxDuration)! }
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, end: maxDuration)
        instruction.layerInstructions = zip(entities, tracks).map({ $0.0.layerInstructions(videoTrack: $0.1) }).flatMap({$0})
        
        let videoComposition = AVMutableVideoComposition()
        videoComposition.instructions = [instruction]
        videoComposition.frameDuration = CMTime(value: 1, timescale: 24)  // FIXME: fps
        videoComposition.renderSize = renderSize
        
        try? FileManager.default.removeItem(at: destination)
        let exportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exportSession?.outputURL = destination
        exportSession?.videoComposition = videoComposition
        exportSession?.outputFileType = .mp4
        exportSession?.shouldOptimizeForNetworkUse = true
        log.debug("start")
        exportSession?.exportAsynchronously {
            log.debug("error: \(String(describing: exportSession?.error))")
            log.debug("success: \(destination.path)")
        }
    }
    
    static func maxDuration(entities: [Entity]) -> CMTime {
        return entities.reduce(CMTime.zero) { $1.asset.duration > $0 ? $1.asset.duration : $0 }
    }
    
    public struct Entity {
        let tileRects: [CGRect]
        let asset: AVAsset
        
        /*!
             @method        videoTrack:composition:duration
             @abstract        获取新生成的视频轨道，如果所需时间大于视频本身时间则视频循环放入轨道
             @param            composition  新轨道从这个`AVMutableComposition`中生成
             @param            duration  这个视频轨道需要播放多长时间
             @result        要生成的轨道，如果为.none就是生成失败了
         */
        public func videoTrack(composition: AVMutableComposition, duration: CMTime) -> AVAssetTrack? {
            guard let assetVideoTrack = asset.tracks(withMediaType: .video).first,
                let track = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
                else { return .none }
            
            do {
                let timeRanges = Entity.timeRangsBy(duration: asset.duration, neededDuration: duration)

                for (timeRange, at) in timeRanges {
                    try track.insertTimeRange(timeRange, of: assetVideoTrack, at: at)
                }
            }
            catch {
                return .none
            }
            return track
        }
        
        public func layerInstructions(videoTrack: AVAssetTrack) -> [AVVideoCompositionLayerInstruction] {
            let instructions: [AVVideoCompositionLayerInstruction] = tileRects.map { rect in
                let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
                instruction.setCropRectangle(rect, at: .zero)
                return instruction
            }
            
            return instructions
        }
        
        public static func timeRangsBy(duration: CMTime, neededDuration: CMTime) -> [(CMTimeRange, CMTime)] {
            assert(duration != .zero, "duration must greater than zero")
            assert(neededDuration != .zero, "neededDuration must greater than zero")
            
            if duration >= neededDuration {
                let timeRange = CMTimeRange(
                    start: .zero,
                    duration: CMTime(seconds: neededDuration.seconds, preferredTimescale: duration.timescale)
                )
                return [(timeRange, .zero)]
            }
            
            var i = 0 as Double
            var timeRanges: [(CMTimeRange, CMTime)] = []
            var restDuration = neededDuration
            while (restDuration > duration) {
                let timeRange = CMTimeRange(
                    start: .zero,
                    duration: duration
                )
                restDuration = restDuration - duration
                timeRanges.append((
                    timeRange, CMTime(seconds: duration.seconds * i, preferredTimescale: duration.timescale)
                ))
                i += 1
            }
            timeRanges.append((CMTimeRange(start: .zero, duration: restDuration), neededDuration - restDuration))
            return timeRanges
        }
        
    }

}


