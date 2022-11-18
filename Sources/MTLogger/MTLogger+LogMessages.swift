/**
 Log message with level LogLevel.debug
 */
public func logDebug(_ info: Any, function: String = #function, file: String = #file, line: Int =  #line) {
    guard Configuration.logLevel < LogLevel.warning else {
        return
    }
    log(info, prefix: "🛠 ", function: function, file: file, line: line)
}

/**
 Log message with level LogLevel.warning
 */
public func logWarning(_ info: Any, function: String = #function, file: String = #file, line: Int = #line) {
    guard Configuration.logLevel < LogLevel.error else {
        return
    }
    log(info, prefix: "⚠️ ", function: function, file: file, line: line)
}

/**
 Log message with level LogLevel.error
 */
public func logError(_ info: Any, function: String = #function, file: String = #file, line: Int = #line) {
    guard Configuration.logLevel < LogLevel.off else {
        return
    }
    log(info, prefix: "⛔️ ", function: function, file: file, line: line)
}

func logLoggerError(_ info: Any, function: String = #function, file: String = #file, line: Int = #line) {
    let wasLogPrint = Configuration.logPrint
    let wasLogLevel = Configuration.logLevel
    Configuration.logPrint = true
    Configuration.logLevel = .error
    log(info, prefix: "⛔️⛔️⛔️ ", function: function, file: file, line: line)
    Configuration.logPrint = wasLogPrint
    Configuration.logLevel = wasLogLevel
}
