//
//  Subtitler_EditorApp.swift
//  Subtitler Editor
//
//  Created by David Lawrence on 9/14/22.
//

import SwiftUI

@main
struct Subtitler_EditorApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: Subtitler_EditorDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
