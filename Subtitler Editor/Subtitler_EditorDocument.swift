//
//  Subtitler_EditorDocument.swift
//  Subtitler Editor
//
//  Created by David Lawrence on 9/14/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let srtText: UTType = UTType(exportedAs: "com.subtitler.srt")
}

struct Subtitler_EditorDocument: FileDocument {
    var subs: [Subtitle] = []

    static var readableContentTypes: [UTType] { [.srtText] }

    init(subs: [Subtitle] = []) {
        self.subs = subs
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }

        subs = try Parser.parse(fromText: string)
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let text = Parser.parse(fromSubs: subs)
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
}
