public enum LogLevel: Int {
    /// Logging with the 'Debug' level will log everything for the porpose of debuggin
    case debug
    /// Logging with the 'Warning' level will log all Warning and Error type messages to keep track only of the potentially problematic messages
    case warning
    /// Logging with the 'critical' level will log all Error type messages to keep track of the critical functionality
    case error
    /// Disables all logging messages - advised for stable and tested release builds
    case off
}

extension LogLevel: Comparable {
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
