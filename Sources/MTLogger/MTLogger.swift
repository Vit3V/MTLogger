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
    write(message: message)
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

fileprivate func write(message: String) {
    guard let file = Configuration.logFile else {
        return
    }
    
    let message = message + "\n"
    Configuration.logBuffer.append(message)
    
    guard Configuration.logBuffer.count >= (Configuration.logFlushBufferLength ?? 0) else {
        return
    }
    
    do {
        let handle = try FileHandle(forUpdating: file)
        for message in Configuration.logBuffer {
            guard let messageData = message.data(using: .utf8) else {
                logLoggerError(LogError.failedToConvertMessageToDataUTF8)
                continue
            }
            _ = try handle.seekToEnd()
            try handle.write(contentsOf: messageData)
        }
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
    Configuration.logBuffer.removeAll()
}
