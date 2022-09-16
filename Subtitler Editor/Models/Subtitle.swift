//
//  Subtitle.swift
//  Subtitler
//
//  Created by David Lawrence on 7/7/22.
//

import Foundation

/// A timestamp contains the hours, minutes, seconds, and milliseconds
/// for when a subtitle will be displayed
struct Timestamp : Hashable {
    var h: Int = 0
    var m: Int = 0
    var s: Int = 0
    var ms: Int = 0
    
    func toString() -> String {
        let hStr = String(h).leftPadding(toLength: 2, withPad: "0")
        let mStr = String(m).leftPadding(toLength: 2, withPad: "0")
        let sStr = String(s).leftPadding(toLength: 2, withPad: "0")
        let msStr = String(ms).leftPadding(toLength: 3, withPad: "0")
        
        return "\(hStr):\(mStr):\(sStr),\(msStr)"
    }
}

/// Represents a subtitle from a srt file
/// Contains an index indicating the order in which
/// the subtitles are to be shown, start and end timestamps for when
/// the subtitle is shown on the screen, and the actual caption content
struct Subtitle : Hashable, Identifiable {
    let id = UUID()
    var index: Int
    var start: Timestamp = Timestamp()
    var end: Timestamp = Timestamp()
    var caption: String = ""
    
    init(index: Int) {
        self.index = index
    }
    
    init(index: Int, start: Timestamp, end: Timestamp, caption: String) {
        self.index = index
        self.start = start
        self.end = end
        self.caption = caption
    }
    
    func toString() -> String {
        var lines: [String]
        
        // If the caption is empty, don't include the line
        if caption.trimmingCharacters(in: .whitespaces) == "" {
            lines = [
                String(index),
                "\(start.toString()) --> \(end.toString())",
                "", // Newline to separate next subtitle
            ]
        } else {
            lines = [
                String(index),
                "\(start.toString()) --> \(end.toString())",
                caption,
                "", // Newline to separate next subtitle
            ]
        }
        
        return lines.joined(separator: "\n")
    }
}

extension Array where Element == Subtitle {
    mutating func insertSub(_ sub: Subtitle, at: Int) {
        self.insert(sub, at: at)
        self.reindex()
    }
    
    mutating func removeSub(at: Int) {
        self.remove(at: at)
        self.reindex()
    }
    
    mutating private func reindex() {
        for idx in 0..<self.count {
            self[idx].index = idx + 1
        }
    }
}
