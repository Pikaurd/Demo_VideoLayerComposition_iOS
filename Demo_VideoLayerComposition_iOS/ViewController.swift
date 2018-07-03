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
//        video_test()
    }
    
    func svg_test() -> () {
        let bundle = Bundle.main
        let url = bundle.url(forResource: "method-draw-image", withExtension: "svg")!
        let paths = SVGBezierPath.pathsFromSVG(at: url)
        print(paths)
    }
    
    func video_test() -> () {
        let bundle = Bundle.main
        let entities = [
            VideoComposition.Entity(
                cgPath: CGPath(rect: .zero, transform: .none),
                asset: AVAsset(url: bundle.url(forResource: "Close Up Video Of Flower", withExtension: "mp4")!)
            ),
//            VideoComposition.Entity(
//                cgPath: CGPath(rect: .zero, transform: .none),
//                asset: AVAsset(url: bundle.url(forResource: "Dog on Boat", withExtension: "mp4")!)
//            ),
        ]
        let vc = VideoComposition(entities: entities, renderSize: CGSize(width: 1920, height: 1080))
        VideoFileSystemHelper.removeAllTempFolders()
        
        let tempFolder = VideoFileSystemHelper.createTempFolder()
        let destination = tempFolder.appendingPathComponent("test.mp4")
        vc.export(to: destination)
    }

}

