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
        
        let bundle = Bundle.main
        let entities = [
            VideoComposition.Entity(transform: .identity, asset: AVAsset(url: bundle.url(forResource: "Close Up Video Of Flower", withExtension: "mp4")!))
        ]
        let vc = VideoComposition(entities: entities, renderSize: CGSize(width: 1920, height: 1080))
        VideoFileSystemHelper.removeAllTempFolders()
        
        let tempFolder = VideoFileSystemHelper.createTempFolder()
        let destination = tempFolder.appendingPathComponent("test.mp4")
        vc.export(to: destination)
    }


}

