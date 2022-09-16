//
//  Parser.swift
//  Subtitler
//
//  Created by David Lawrence on 7/7/22.
//

import Foundation

/// Reads a srt string into data structures
class Parser {
    
    /// Converts a string from a .srt file into an array of Subtitle structs representing each subtitle
    static func parse(fromText text: String) throws -> [Subtitle] {
        var subs: [Subtitle] = []
        //  lineNumber tracks the current line in the file being parsed to report to the user where the parsing error occured
        var lineNumber = 1

        // after normalization, we can split on 2 newlines
        for subtitleText in normalize(text).components(separatedBy: "\n\n") {
            // There could be captions that contain excessive empty lines which need to be trimmed off
            let normalizedText = subtitleText.trimmingCharacters(in: .whitespacesAndNewlines)
            if normalizedText == "" {
                continue
            }
            let (sub, lines) = try parseSubtitle(from: normalizedText, lineNumber: lineNumber)
            subs.append(sub)
            lineNumber += lines
        }

        return subs
    }
    
    /// Converts subtitles back to a string
    static func parse(fromSubs subs: [Subtitle]) -> String {
        return subs.map { $0.toString() }.joined(separator: "\n")
    }
    
    /// This trims every line and rejoins with newlines.
    /// Each subtitle in an SRT file is separated by an empty line. So in theory, they can be split on 2 newline characters. However, the empty lines may contain whitespace, and Swift does not support splitting with regular expressions. This normalizes the srt string to handle this edge case.
    /// It also handles text that has newlines that may not be expressed as single \n characters.
    private static func normalize(_ text: String) -> String {
        return text.components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines.union(CharacterSet(charactersIn: "\r"))).filter(\.isZeroWidthSpace.negated) }
            .joined(separator: "\n")
    }
    
    private static func parseSubtitle(from text: String, lineNumber: Int) throws -> (Subtitle, Int) {
        let lines = text.components(separatedBy: "\n")

        guard let index = Int(lines[0]), index > 0 else {
            throw ParseError.invalidIndex(lineNumber, text)
        }
        
        let (startTs, endTs) = try parseTimestamps(from: lines[1], lineNumber: lineNumber + 1)
        let captionLines = lines[2...]
        let numCaptionLines = captionLines.count
        let caption = captionLines.joined(separator: "\n")
        
        // 2 for the index and timestamps, plus the length of the caption, and 1 for the newline
        let nextLineNum = 2 + numCaptionLines + 1
        
        return (Subtitle(index: index, start: startTs, end: endTs, caption: caption), nextLineNum)
    }
    
    private static func parseTimestamps(from text: String, lineNumber: Int) throws -> (Timestamp, Timestamp) {
        let timestamps = text.components(separatedBy: " --> ")
              
        if timestamps.count != 2 {
            throw ParseError.invalidTimestamps(lineNumber)
        }
        
        return (try parseTimestamp(from: timestamps[0], line: lineNumber, kind: "starting"), try parseTimestamp(from: timestamps[1], line: lineNumber, kind: "ending"))
    }
    
    /// Parses a string in the form of HH:SS:MM,sss to a Timestamp struct of hours, minutes, seconds, and milliseconds.
    /// Checks that each time value is valid. Hours, minutes, and seconds must be bewteen 0 - 59, while milliseconds must be between 0 - 999
    private static func parseTimestamp(from str: String, line: Int, kind: String) throws -> Timestamp {
        let timeMs = str.components(separatedBy: ",")
        if timeMs.count != 2 {
            throw ParseError.invalidTimestampFormat(line, kind)
        }
        
        let hms = timeMs[0].components(separatedBy: ":")
        if hms.count != 3 {
            throw ParseError.invalidTimestampFormat(line, kind)
        }
        
        guard let h = Int(hms[0]) else {
            throw ParseError.invalidTimestampHours(line, kind)
        }
                
        guard let m = Int(hms[1]) else {
            throw ParseError.invalidTimestampMinutes(line, kind)
        }
        
        guard let s = Int(hms[2]) else {
            throw ParseError.invalidTimestampSeconds(line, kind)
        }
              
        guard let ms = Int(timeMs[1]) else {
            throw ParseError.invalidTimestampMillisecods(line, kind)
        }

        return Timestamp(h: h, m: m, s: s, ms: ms)
    }
}

enum ParseError : Error, LocalizedError {
    case invalidIndex(Int, String)
    case invalidTimestamps(Int)
    case invalidTimestampFormat(Int, String)
    case invalidTimestampHours(Int, String)
    case invalidTimestampMinutes(Int, String)
    case invalidTimestampSeconds(Int, String)
    case invalidTimestampMillisecods(Int, String)
    
    var lineNumber: Int { get {
        switch self {
        case .invalidIndex(let lineNumber, _):
            return lineNumber
        case .invalidTimestamps(let lineNumber):
            return lineNumber
        case .invalidTimestampFormat(let lineNumber, _):
            return lineNumber
        case .invalidTimestampHours(let lineNumber, _):
            return lineNumber
        case .invalidTimestampMinutes(let lineNumber, _):
            return lineNumber
        case .invalidTimestampSeconds(let lineNumber, _):
            return lineNumber
        case .invalidTimestampMillisecods(let lineNumber, _):
            return lineNumber
        }
    }}
    
    var errorDescription: String? { get {
        switch self {
        case .invalidIndex(let lineNumber, let line):
            return NSLocalizedString("Invalid index on line \(lineNumber): \(line)", comment: "")
        case .invalidTimestamps(let lineNumber):
            return NSLocalizedString("Invalid timestamps on line \(lineNumber)", comment: "")
        case .invalidTimestampFormat(let lineNumber, let kind):
            return NSLocalizedString("Invalid format for \(kind) timestamp on line \(lineNumber)", comment: "")
        case .invalidTimestampHours(let lineNumber, let kind):
            return NSLocalizedString("Invalid hours in \(kind) timestamp on line \(lineNumber)", comment: "")
        case .invalidTimestampMinutes(let lineNumber, let kind):
            return NSLocalizedString("Invalid minutes in \(kind) timestamp on line \(lineNumber)", comment: "")
        case .invalidTimestampSeconds(let lineNumber, let kind):
            return NSLocalizedString("Invalid seconds in \(kind) timestamp on line \(lineNumber)", comment: "")
        case .invalidTimestampMillisecods(let lineNumber, let kind):
            return NSLocalizedString("Invalid milliseconds in \(kind) timestamp on line \(lineNumber)", comment: "")
        }
    }}
    
    var failureReason: String? { get {
        switch self {
        case .invalidIndex(let lineNumber, let line):
            return NSLocalizedString("Failed to parse index on line \(lineNumber). Index must be a positive integer: \(line)", comment: "")
        case .invalidTimestamps(let lineNumber):
            return NSLocalizedString("Failed to parse timestamps on line \(lineNumber). Timestamps must be separated by ' --> '", comment: "")
        case .invalidTimestampFormat(let lineNumber, let kind):
            return NSLocalizedString("Failed to parse \(kind) timestamp on line \(lineNumber). Timestamp must be formatted as HH:MM:SS,mmm", comment: "")
        case .invalidTimestampHours(let lineNumber, let kind):
            return NSLocalizedString("Failed to parse hours in \(kind) timestamp on line \(lineNumber). Hours must be between 0 - 99", comment: "")
        case .invalidTimestampMinutes(let lineNumber, let kind):
            return NSLocalizedString("Failed to parse minutes in \(kind) timestamp on line \(lineNumber). Minutes must be between 0 - 59", comment: "")
        case .invalidTimestampSeconds(let lineNumber, let kind):
            return NSLocalizedString("Failed to parse seconds in \(kind) timestamp on line \(lineNumber). Seconds must be between 0 - 59", comment: "")
        case .invalidTimestampMillisecods(let lineNumber, let kind):
            return NSLocalizedString("Failed to parse milliseconds in \(kind) timestamp on line \(lineNumber). Milliseconds must be between 0 - 999", comment: "")
        }
    }}
    
    var recoverySuggestion: String? { get {
        switch self {
        case .invalidIndex:
            return NSLocalizedString("Update index to any positive integer.", comment: "")
        case .invalidTimestamps:
            return NSLocalizedString("Ensure timestamps are properly formatted", comment: "")
        case .invalidTimestampFormat:
            return NSLocalizedString("Ensure timestamps are properly formatted", comment: "")
        case .invalidTimestampHours:
            return NSLocalizedString("Update hours to a valid value", comment: "")
        case .invalidTimestampMinutes:
            return NSLocalizedString("Update minutes to a valid value", comment: "")
        case .invalidTimestampSeconds:
            return NSLocalizedString("Update seconds to a valid value", comment: "")
        case .invalidTimestampMillisecods:
            return NSLocalizedString("Update milliseconds to a valid value", comment: "")
        }
    }}
}
