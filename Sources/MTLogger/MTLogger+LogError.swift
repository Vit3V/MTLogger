enum LogError: String, Error {
    case invalidLoggerDirectoryPath = "Invalid logger directory path!"
    case failedToWriteMessageToLog = "Failed to write message to log, so log writing to file has been disabled!"
    case failedToConvertMessageToDataUTF8 = "Failed to convert message to data protocol using UTF8 encoding!"
    case failedToCreateLogFile = "Failed to create log file!"
}
