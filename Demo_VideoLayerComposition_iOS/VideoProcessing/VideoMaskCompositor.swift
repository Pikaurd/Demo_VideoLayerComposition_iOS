//
//  VideoMaskCompositor.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/7/3.
//

import AVKit
import VideoToolbox


class VideoMaskCompositor: NSObject, AVVideoCompositing {
    private let _backgroundPath: CGPath
    private let _cgPathes: [CGPath]
    
    override init() {
        let path = CGPath(rect: CGRect(origin: .zero, size: CGSize(width: 960, height: 540)), transform: .none)
        _backgroundPath = path
        _cgPathes = [path]
        super.init()
    }

    var backgroundPath: CGPath {
        get {
            return _backgroundPath
        }
    }
    
    var cgPaths: [CGPath] {
        get {
            return _cgPathes
        }
    }
    
    var sourcePixelBufferAttributes: [String : Any]? {
        return [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    }
    
    var requiredPixelBufferAttributesForRenderContext: [String : Any] {
        return [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
    }
    
    func renderContextChanged(_ newRenderContext: AVVideoCompositionRenderContext) {
        // do anything in here you need to before you start writing frames
    }
    
    func startRequest(_ asyncVideoCompositionRequest: AVAsynchronousVideoCompositionRequest) {
        // called for every frame
        guard let buffer = asyncVideoCompositionRequest.renderContext.newPixelBuffer() else { fatalError("create new pixel buffer failed") }
//        assert(cgPaths.count == asyncVideoCompositionRequest.sourceTrackIDs.count, "source track count must match cgPaths count")
        let flag = CVPixelBufferLockFlags(rawValue: 0)
        defer {
            CVPixelBufferLockBaseAddress(buffer, flag)
        }
        CVPixelBufferLockBaseAddress(buffer, flag)
        guard
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: CVPixelBufferGetWidth(buffer),
            height: CVPixelBufferGetHeight(buffer),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        )
            else {
                CVPixelBufferUnlockBaseAddress(buffer, flag)
                fatalError("create image failed")
        }

        context.setFillColor(red: 1, green: 1, blue: 0, alpha: 1)
        context.fill(CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(buffer), height: CVPixelBufferGetHeight(buffer)))
        
        asyncVideoCompositionRequest.finish(withComposedVideoFrame: buffer)
        
    }
    
    class func cgImage(from buffer: CVPixelBuffer) -> CGImage? {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(buffer, .none, &cgImage)
        return cgImage
    }
    
    class func createBlankImage(size: CGSize, red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGImage? {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(
            data: .none,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue
        )
    
//        let rectPath = CGPath(rect: CGRect(origin: .zero, size: size), transform: .none)
//        context?.addPath(rectPath)
        context?.setFillColor(red: red, green: green, blue: blue, alpha: alpha)
        context?.fill(CGRect(origin: .zero, size: size))
        let image = context?.makeImage()
        return image
    }
    
}
