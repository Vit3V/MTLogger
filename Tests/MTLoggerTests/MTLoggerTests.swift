import Foundation
import XCTest
@testable import MTLogger

final class MTLoggerTests: XCTestCase {
    override func tearDown() {
        guard let logFile = Configuration.logFile else {
            return
        }
        try! FileManager.default.removeItem(at: logFile)
    }
}

// MARK: - File logging
extension MTLoggerTests {
    func test_configurationSuccess_whenDirPathNotNil() {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let currentDirectoryURL = URL(fileURLWithPath: currentDirectory, isDirectory: false)
        let logDirectory = currentDirectoryURL.appendingPathComponent("logs", isDirectory: true)
        do {
            try configureLogger(
                logDirectoryPath: logDirectory.path,
                level: .debug,
                print: true,
                flushBufferLength: nil
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNotNil(Configuration.logFile)
        XCTAssertTrue(FileManager.default.fileExists(atPath: Configuration.logFile!.path))
    }
    
    func test_configurationSuccess_whenDirURLNotNil() {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let currentDirectoryURL = URL(fileURLWithPath: currentDirectory, isDirectory: false)
        let logDirectory = currentDirectoryURL.appendingPathComponent("logs", isDirectory: true)
        do {
            try configureLogger(
                logDirectoryURL: logDirectory,
                level: .debug,
                print: true,
                flushBufferLength: nil
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        XCTAssertNotNil(Configuration.logFile)
        XCTAssertTrue(FileManager.default.fileExists(atPath: Configuration.logFile!.path))
    }
    
    func test_writeMessageToFileSuccess() {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let currentDirectoryURL = URL(fileURLWithPath: currentDirectory, isDirectory: false)
        let logDirectory = currentDirectoryURL.appendingPathComponent("logs", isDirectory: true)
        do {
            try configureLogger(
                logDirectoryURL: logDirectory,
                level: .debug,
                print: true,
                flushBufferLength: nil
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        logDebug("Unit testy!")
        logDebug("Unit testy 222!")
        let attributes = try! FileManager.default.attributesOfItem(atPath: Configuration.logFile!.path)
        let size = attributes[.size] as! UInt64
        XCTAssertTrue(size > 0)
    }
    
    func test_writeMessageToFileSuccess_whenFlushBufferLengthIsGreaterThanOne() {
        let currentDirectory = FileManager.default.currentDirectoryPath
        let currentDirectoryURL = URL(fileURLWithPath: currentDirectory, isDirectory: false)
        let logDirectory = currentDirectoryURL.appendingPathComponent("logs", isDirectory: true)
        do {
            try configureLogger(
                logDirectoryURL: logDirectory,
                level: .debug,
                print: true,
                flushBufferLength: 2
            )
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        logDebug("Unit testy!")
        var attributes = try! FileManager.default.attributesOfItem(atPath: Configuration.logFile!.path)
        var size = attributes[.size] as! UInt64
        XCTAssertTrue(size == 0)
        
        logDebug("Unit testy 222!")
        attributes = try! FileManager.default.attributesOfItem(atPath: Configuration.logFile!.path)
        size = attributes[.size] as! UInt64
        XCTAssertTrue(size > 0)
    }
}
