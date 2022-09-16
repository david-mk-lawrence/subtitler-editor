//
//  NavbarView.swift
//  Subtitler
//
//  Created by David Lawrence on 7/9/22.
//

import SwiftUI

struct ToolbarView : View {
    var canUndo: Bool
    var canRedo: Bool
    var onUndo: () -> Void
    var onRedo: () -> Void

    var body: some View {
        Button(action: onUndo) {
            Image(systemName: "arrow.uturn.backward")
        }.disabled(!canUndo)
        Button(action: onRedo) {
            Image(systemName: "arrow.uturn.forward")
        }.disabled(!canRedo)
    }
}

struct ToolbarView_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView(
            canUndo: true, canRedo: false, onUndo: {}, onRedo: {}
        )
    }
}
