import Foundation

enum Configuration {
    static var logDir: URL?
    static var logFile: URL?
    static var logLevel = LogLevel.debug
    static var logPrint = true
    static var logFlushBufferLength: Int?
    static var logBuffer: [String] = []
    fileprivate static let logExtension = "log"
}

/**
 logDirectoryPath - directory, where all the log files will be generated
 level - define a logging level that will log only the data you require
 print - enables printing the logger messages in the Console
 flushBufferLength - sets the length of the message buffer. Once the message count in the buffer reaches this value - the messages will be flushed to the log file (use this to minimize file writing in case of intense logging sessions)
 */
public func configureLogger(logDirectoryPath: String? = nil, level: LogLevel = .debug, print: Bool = true, flushBufferLength: Int? = nil) throws {
    if let path = logDirectoryPath {
        do {
            Configuration.logDir = try createDirectory(path: path)
            Configuration.logFile = try createLogFile()
        }
    }
    Configuration.logLevel = level
    Configuration.logPrint = print
    Configuration.logFlushBufferLength = flushBufferLength
}

/**
 logDirectoryURL - directory, where all the log files will be generated
 level - define a logging level that will log only the data you require
 print - enables printing the logger messages in the Console
 flushBufferLength - sets the length of the message buffer. Once the message count in the buffer reaches this value - the messages will be flushed to the log file (use this to minimize file writing in case of intense logging sessions)
 */
public func configureLogger(logDirectoryURL: URL? = nil, level: LogLevel = .debug, print: Bool = true, flushBufferLength: Int? = nil) throws {
    try configureLogger(logDirectoryPath: logDirectoryURL?.path, level: level, print: print, flushBufferLength: flushBufferLength)
}

func createDirectory(path: String) throws -> URL {
    let url = URL(fileURLWithPath: path, isDirectory: path.last != "/")
    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    } catch {
        throw error
    }
    return url
}

func createLogFile() throws -> URL? {
    guard let logDir = Configuration.logDir else {
        return nil
    }
    
    let df = DateFormatter()
    df.dateFormat = "YYYYMMdd-HHmmss"
    
    let logFilename = df.string(from: Date())
    let logFilePath = logDir
        .appendingPathComponent(logFilename)
        .appendingPathExtension(Configuration.logExtension)
    
    guard FileManager.default.createFile(atPath: logFilePath.path, contents: nil) else {
        throw LogError.failedToCreateLogFile
    }
    return logFilePath
}

