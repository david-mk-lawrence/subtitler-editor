//
//  SubtitleView.swift
//  Subtitler
//
//  Created by David Lawrence on 7/10/22.
//

import SwiftUI

struct SubtitleView : View {
    @Binding var sub: Subtitle
    var removeSub: (Int) -> Void
    var bgColor: Color = .clear

    var body: some View {
        HStack {
            HStack {
                Text(String(sub.index))
            }
            .padding()

            VStack {
                TimestampView(ts: $sub.start)
                TimestampView(ts: $sub.end)
            }
            .padding(5)

            VStack {
                TextEditor(text: $sub.caption)
                    .font(.title3)
                    .background(bgColor)
            }
            .padding([.top, .bottom], 5)
            .padding([.leading, .trailing], 3)

            VStack {
                Button(action: onRemoveSub) {
                    Image(systemName: "delete.left")
                }
                .help(NSLocalizedString("Delete Subtitle", comment: ""))
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    func onRemoveSub() {
        removeSub(sub.index)
    }
}

struct SubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        SubtitleView(sub: .constant(
            Subtitle(index: 1, start: Timestamp(h: 0, m: 0, s: 0, ms: 0), end: Timestamp(h: 0, m: 0, s: 1, ms: 0), caption: "Preview caption 1")
            ),
            removeSub: { idx in },
            bgColor: .clear
        )
    }
}
