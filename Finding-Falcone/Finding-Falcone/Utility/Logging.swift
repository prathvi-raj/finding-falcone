//
//  Logging.swift
//  Finding-Falcone
//
//  Created by Prathvi on 31/05/20.
//  Copyright © 2020 Prathvi. All rights reserved.
//

import Foundation

/**
 Prints the filename, function name, line number and textual representation of `object` and a newline character into
 the standard output if the Environment.DEBUG is true in Constants.swift.
 
 The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
 
 Only the first parameter needs to be passed to this funtion.
 
 The textual representation is obtained from the `object` using `String(reflecting:)` which works for _any_ type.
 To provide a custom format for the output make your object conform to `CustomDebugStringConvertible` and provide your format in
 the `debugDescription` parameter.
 
 :param: object   The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
 :param: file     The name of the file, defaults to the current file without the ".swift" extension.
 :param: function The name of the function, defaults to the function within which the call is made.
 :param: line     The line number, defaults to the line number within the file that the call is made.
 */

public func plog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    
    let value = object()
    let fileURL = URL(fileURLWithPath: file).lastPathComponent
    let queue = Thread.isMainThread ? "UI" : "BG"
    
    let toPrint: String = "<\(queue)> \(fileURL) \(function)[\(line)]: " + String(reflecting: value)
    
    Log.logger.printToConsole = false
    Log.logger.write(toPrint)
    
    NSLog(toPrint)
}
