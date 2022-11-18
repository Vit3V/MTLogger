import Foundation

fileprivate var dateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "HH:mm:ss"
    return df
}()

func log(_ info: Any, prefix: String, function: String = #function, file: String = #file, line: Int = #line) {
    guard Configuration.logPrint || Configuration.logFile != nil else {
        return
    }
    
    let now = dateFormatter.string(from: Date())
    let filenameString = getFilename(from: file)
    let functionString = getMethodName(from: function)
    let message = "\(prefix)\(now) [\(filenameString):\(functionString):\(line)] \(info)"
    
    if Configuration.logPrint {
        print(message)
    }
    guard let file = Configuration.logFile else {
        return
    }
    write(message: message, to: file)
}

fileprivate func getFilename(from file: String) -> String {
    var filenameString = file
    if let filename = file.split(separator: "/").last {
        filenameString = String(filename)
    }
    return filenameString
}

fileprivate func getMethodName(from function: String) -> String {
    var functionString = function
    if let function = function.split(separator: "(").first {
        functionString = String(function)
    }
    return functionString
}

fileprivate func write(message: String, to file: URL) {
    let message = message + "\n"
    guard let messageData = message.data(using: .utf8) else {
        logLoggerError(LogError.failedToConvertMessageToDataUTF8)
        return
    }
    do {
        let handle = try FileHandle(forUpdating: file)
        _ = try handle.seekToEnd()
        try handle.write(contentsOf: messageData)
        try handle.close()
    } catch {
        Configuration.logFile = nil
        guard Configuration.logPrint else {
            return
        }
        logLoggerError(error)
        logLoggerError(error)
        logLoggerError(LogError.failedToWriteMessageToLog)
        logLoggerError("The failed log file: \(file.path)")
    }
}
