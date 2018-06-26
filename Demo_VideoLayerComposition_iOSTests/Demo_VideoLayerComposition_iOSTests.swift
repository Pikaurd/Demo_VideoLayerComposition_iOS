//
//  Demo_VideoLayerComposition_iOSTests.swift
//  Demo_VideoLayerComposition_iOSTests
//
//  Created by hirochin on 2018/6/26.
//


import AVKit
import Quick
import Nimble


class Demo_VideoLayerComposition_iOSTestsSpec: QuickSpec {
    
    override func spec() {
        
        describe("VideoComposition.Entity Time and Duration") {
            it("Source duration greater then needed duration") {
                let assetDuration = CMTime(seconds: 15, preferredTimescale: 600)
                let neededDuration = CMTime(seconds: 10, preferredTimescale: 600)
                let ts = VideoComposition.Entity.timeRangsBy(duration: assetDuration, neededDuration: neededDuration)
                
                expect(ts.count).to(equal(1))
                expect(ts[0].0.start).to(equal(.zero))
                expect(ts[0].0.duration.seconds).to(equal(10))
                expect(ts[0].1).to(equal(.zero))
            }
            
            it("Source duration equal needed") {
                let assetDuration = CMTime(seconds: 10, preferredTimescale: 600)
                let neededDuration = CMTime(seconds: 10, preferredTimescale: 1600)
                let ts = VideoComposition.Entity.timeRangsBy(duration: assetDuration, neededDuration: neededDuration)
                expect(ts.count).to(equal(1))
                expect(ts[0].0.start).to(equal(.zero))
                expect(ts[0].0.duration.seconds).to(equal(10))
                expect(ts[0].1).to(equal(.zero))
            }
            
            it("Source duration less than needed") {
                let assetDuration = CMTime(seconds: 2.1, preferredTimescale: 600)
                let neededDuration = CMTime(seconds: 10, preferredTimescale: 600)
                let ts = VideoComposition.Entity.timeRangsBy(duration: assetDuration, neededDuration: neededDuration)

                expect(ts.count).to(equal(5))
                
                var i = 0
                var (r, s) = ts[i]
                expect(r.start).to(equal(.zero))
                expect(r.duration.seconds).to(equal(assetDuration.seconds))
                expect(s.seconds).to(equal(assetDuration.seconds * Double(i)))
                
                i = 1
                (r, s) = ts[i]
                expect(r.start).to(equal(.zero))
                expect(r.duration.seconds).to(equal(assetDuration.seconds))
                expect(s.seconds).to(equal(assetDuration.seconds * Double(i)))
                
                i = 4
                (r, s) = ts[i]
                expect(r.start).to(equal(.zero))
                expect(r.duration.seconds).to(equal(1.6))
                expect(s.seconds).to(equal(4 * assetDuration.seconds))
            }
            
//            context("if it doesn't have what you're looking for") {
//                it("needs to be updated") {
//
//                    expect{false}.toEventually(beTruthy())
//                }
//            }
        }
        
    }
    
}

