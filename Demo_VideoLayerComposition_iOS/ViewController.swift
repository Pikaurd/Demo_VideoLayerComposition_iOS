//
//  ViewController.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/6/25.
//

import AVKit
import UIKit
import PocketSVG

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        svg_test()
        video_test()
    }
    
    func svg_test() -> () {
        let bundle = Bundle.main
        let url = bundle.url(forResource: "method-draw-image", withExtension: "svg")!
        let paths = SVGBezierPath.pathsFromSVG(at: url)
//        print(paths)
        
        let rectPath = paths[0].cgPath
        print(rectPath)
        
        let transformPointer = UnsafeMutablePointer<CGAffineTransform>.allocate(capacity: 1)
        transformPointer.pointee = CGAffineTransform(rotationAngle: .pi * 0.5)
            .scaledBy(x: 2, y: 2)
            .translatedBy(x: 0, y: -rectPath.boundingBoxOfPath.height)
        
        let transformedPath = rectPath.copy(using: transformPointer)!
        print(transformedPath.boundingBoxOfPath.round())
        
        SharedState.default.pathes = paths.dropFirst().map { $0.cgPath.copy(using: transformPointer)! }
        print("SharedState.default.pathes: \(SharedState.default.pathes)")
    }
    
    func video_test() -> () {
        let bundle = Bundle.main
        let entities = [
            VideoComposition.Entity(
                cgPath: CGPath(rect: .zero, transform: .none),
                asset: AVAsset(url: bundle.url(forResource: "Close Up Video Of Flower", withExtension: "mp4")!)
            ),
            VideoComposition.Entity(
                cgPath: CGPath(rect: .zero, transform: .none),
                asset: AVAsset(url: bundle.url(forResource: "Dog on Boat", withExtension: "mp4")!)
            ),
        ]
        let vc = VideoComposition(entities: entities, renderSize: CGSize(width: 1920, height: 1080))
        VideoFileSystemHelper.removeAllTempFolders()
        
        let tempFolder = VideoFileSystemHelper.createTempFolder()
        let destination = tempFolder.appendingPathComponent("test.mp4")
        vc.export(to: destination)
    }

}

// MARK: - CGRect

extension CGRect {
    public func round() -> CGRect {
        return CGRect(x: Darwin.round(origin.x), y: Darwin.round(origin.y), width: Darwin.round(width), height: Darwin.round(height))
    }
}
