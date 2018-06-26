//
//  Logger.swift
//  Demo_VideoLayerComposition_iOS
//
//  Created by hirochin on 2018/5/9.
//

import Foundation


let log = Logger.self


#if DEBUG
class Logger {
    class func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line) -> () {
        let fileName = file.split(separator: "/").last ?? "unknow"
        print("[D] \(fileName) #\(line) >-> \(function): \(message()) <-<")
    }
    
    class func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line) -> () {
        let fileName = file.split(separator: "/").last ?? "unknow"
        print("[V] \(fileName) #\(line) >-> \(function): \(message()) <-<")
    }
}
#else
class Logger {
    class func debug(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line) -> () {}
    
    class func verbose(_ message: @autoclosure () -> Any, _ file: String = #file, _ function: String = #function, line: Int = #line) -> () {}
}
#endif
