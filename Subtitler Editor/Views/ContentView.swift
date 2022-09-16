//
//  ContentView.swift
//  Subtitler
//
//  Created by David Lawrence on 7/2/22.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.undoManager) var undoManager
    @Binding var document: Subtitler_EditorDocument

    @State var canUndo: Bool = false
    @State var canRedo: Bool = false

    var body: some View {
        ScrollView {
            EditorView(subs: $document.subs, onChange: onSubsChange)
                .frame(maxWidth: .infinity)
                .toolbar {
                    ToolbarView(canUndo: canUndo, canRedo: canRedo, onUndo: undo, onRedo: redo)
                }
        }.onAppear(perform: setup)
    }

    func setup() {
        resetUndoRedo()
    }

    func onSubsChange() {
        resetUndoRedo()
    }

    func undo() {
        undoManager?.undo()
        resetUndoRedo()
    }

    func redo() {
        undoManager?.redo()
        resetUndoRedo()
    }

    func resetUndoRedo() {
        canUndo = undoManager?.canUndo ?? false
        canRedo = undoManager?.canRedo ?? false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let doc = Subtitler_EditorDocument(subs: [
            Subtitle(index: 1, start: Timestamp(h: 0, m: 0, s: 0, ms: 0), end: Timestamp(h: 0, m: 0, s: 1, ms: 0), caption: "Preview caption 1"),
            Subtitle(index: 2, start: Timestamp(h: 0, m: 0, s: 2, ms: 0), end: Timestamp(h: 0, m: 0, s: 4, ms: 0), caption: "Preview caption 2")
        ])

        ContentView(document: .constant(doc))
    }
}
