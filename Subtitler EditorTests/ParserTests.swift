//
//  ParserTests.swift
//  SubtitlerTests
//
//  Created by David Lawrence on 7/7/22.
//

import XCTest
@testable import Subtitler_Editor

class ParserTests: XCTestCase {
    func testValidSRT() throws {
        let srtStr = "1\n00:01:01,111 --> 00:01:02,000\nCaption 1\n  \n2\n00:01:02,000 --> 00:01:03,000\nCaption 2 Line 1\nCaption 2 Line 2\n\n300:01:02,000 --> 00:01:03,000\n\n\n\n\n4\n00:01:02,000 --> 00:01:03,000\nCaption 4\n\n"
        let subs = try Parser.parse(fromText: srtStr)
        
        XCTAssertEqual(subs.count, 4)
        
        let sub1 = subs[0]
        let sub2 = subs[1]
        let sub3 = subs[2]
        let sub4 = subs[3]

        XCTAssertEqual(sub1.index, 1)
        XCTAssertEqual(sub1.start.h, 0)
        XCTAssertEqual(sub1.start.m, 1)
        XCTAssertEqual(sub1.start.s, 1)
        XCTAssertEqual(sub1.start.ms, 111)
        XCTAssertEqual(sub1.end.h, 0)
        XCTAssertEqual(sub1.end.m, 1)
        XCTAssertEqual(sub1.end.s, 2)
        XCTAssertEqual(sub1.end.ms, 0)
        XCTAssertEqual(sub1.caption, "Caption 1")
        
        XCTAssertEqual(sub2.index, 2)
        XCTAssertEqual(sub2.start.h, 0)
        XCTAssertEqual(sub2.start.m, 1)
        XCTAssertEqual(sub2.start.s, 2)
        XCTAssertEqual(sub2.start.ms, 000)
        XCTAssertEqual(sub2.end.h, 0)
        XCTAssertEqual(sub2.end.m, 1)
        XCTAssertEqual(sub2.end.s, 3)
        XCTAssertEqual(sub2.end.ms, 0)
        XCTAssertEqual(sub2.caption, "Caption 2 Line 1\nCaption 2 Line 2")
        
        XCTAssertEqual(sub3.caption, "")
        XCTAssertEqual(sub4.caption, "Caption 4")
    }
    
    func testInvalidIndex() throws {
        let srtStr = "foo\n00:01:01,111 --> 00:01:02,000\nCaption 1"
        var thrown: Error?
        
        XCTAssertThrowsError(try Parser.parse(fromText: srtStr)) {
            thrown = $0
        }
        
        XCTAssertTrue(thrown is ParseError, "Unexpected error type: \(type(of: thrown))")
        
        let thrownSRTError = thrown as! ParseError
        XCTAssertEqual(thrownSRTError.lineNumber, 1)
    }
    
    func testInvalidTimestampFormat() throws {
        let srtStr = "1\n00:01:01,111 -> 00:01:02,000\nCaption 1"
        var thrown: Error?
        
        XCTAssertThrowsError(try Parser.parse(fromText: srtStr)) {
            thrown = $0
        }
        
        XCTAssertTrue(thrown is ParseError, "Unexpected error type: \(type(of: thrown))")
        
        let thrownSRTError = thrown as! ParseError
        XCTAssertEqual(thrownSRTError.lineNumber, 2)
    }
    
    func testInvalidFormatInStartTimestamp() throws {
        let srtStr = "1\n00:00:01:111 --> 00:01:02,000\nCaption 1"
        var thrown: Error?
        
        XCTAssertThrowsError(try Parser.parse(fromText: srtStr)) {
            thrown = $0
        }
        
        XCTAssertTrue(thrown is ParseError, "Unexpected error type: \(type(of: thrown))")
        
        let thrownSRTError = thrown as! ParseError
        XCTAssertEqual(thrownSRTError.lineNumber, 2)
    }
    
    func testInvalidValueTypeInStartTimestamp() throws {
        let srtStr = "1\n00:aa:01,111 --> 00:01:02,000\nCaption 1"
        var thrown: Error?
        
        XCTAssertThrowsError(try Parser.parse(fromText: srtStr)) {
            thrown = $0
        }
        
        XCTAssertTrue(thrown is ParseError, "Unexpected error type: \(type(of: thrown))")
        
        let thrownSRTError = thrown as! ParseError
        XCTAssertEqual(thrownSRTError.lineNumber, 2)
    }
    
    func testSubsToString() throws {
        let subs: [Subtitle] = [
            Subtitle(index: 1, start: Timestamp(h: 0, m: 1, s: 1, ms: 100), end: Timestamp(h: 0, m: 2, s: 2, ms: 200), caption: "Caption 1"),
            Subtitle(index: 2, start: Timestamp(h: 0, m: 3, s: 3, ms: 300), end: Timestamp(h: 0, m: 4, s: 4, ms: 400), caption: "Caption 2 Line 1\nCaption 2 Line 2"),
        ]
        
        let srtStr = Parser.parse(fromSubs: subs)
        
        XCTAssertEqual(srtStr, "1\n00:01:01,100 --> 00:02:02,200\nCaption 1\n\n2\n00:03:03,300 --> 00:04:04,400\nCaption 2 Line 1\nCaption 2 Line 2\n")
    }
}
