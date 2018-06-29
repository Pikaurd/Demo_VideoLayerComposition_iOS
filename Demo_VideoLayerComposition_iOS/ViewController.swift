//
//  ViewController.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/6/25.
//

import AVKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let entities = [
            entity1(),
            entity2()
        ]
        let vc = VideoComposition(entities: entities, renderSize: CGSize(width: 1920, height: 1080))
        VideoFileSystemHelper.removeAllTempFolders()
        
        let tempFolder = VideoFileSystemHelper.createTempFolder()
        let destination = tempFolder.appendingPathComponent("test.mp4")
        vc.export(to: destination)
    }

    func entity1() -> VideoComposition.Entity {
        let ratio = 0.5625
        let width = 1920
        let step: Double = 4
        
        let vs:[Int] = (1...width).map { Int(ceil(Double($0) / step)) }
        let rles = vs.reduce([]) { (acc, x) -> [(Int, Int)] in
            guard let (i, l) = acc.last else { return acc + [(x, 1)] }
            
            if i == x {
                return acc.dropLast() + [(x, l + 1)]
            }
            return acc + [(x, 1)]
        }
        let rects = rles.reduce([]) { (acc, x) -> [CGRect] in
            let height = round(Double(x.0) * step * ratio)
            return acc + [CGRect(x: Double(x.0) * step, y: 0, width: step, height: height)]
        }
        
        let bundle = Bundle.main
        let entity = VideoComposition.Entity(
            tileRects: rects,
            asset: AVAsset(url: bundle.url(forResource: "Close Up Video Of Flower", withExtension: "mp4")!)
        )
        return entity
    }
    
    func entity2() -> VideoComposition.Entity {
        let ratio = 0.5625
        let width = 1920
        let step: Double = 4
        
        let vs:[Int] = (1...width).map { Int(ceil(Double($0) / step)) }
        let rles = vs.reduce([]) { (acc, x) -> [(Int, Int)] in
            guard let (i, l) = acc.last else { return acc + [(x, 1)] }
            
            if i == x {
                return acc.dropLast() + [(x, l + 1)]
            }
            return acc + [(x, 1)]
        }
        let rects = rles.reduce([]) { (acc, x) -> [CGRect] in
            let height = round(Double(x.0) * step * ratio)
            return acc + [CGRect(x: Double(x.0) * step, y: height, width: step, height: 1080 - height)]
        }
        
        let bundle = Bundle.main
        let entity = VideoComposition.Entity(
            tileRects: rects,
            asset: AVAsset(url: bundle.url(forResource: "Dog on Boat", withExtension: "mp4")!)
        )
        return entity
    }

}

