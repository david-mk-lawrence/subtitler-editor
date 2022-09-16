//
//  MainView.swift
//  Subtitler
//
//  Created by David Lawrence on 7/9/22.
//

import SwiftUI

struct EditorView : View {
    @Binding var subs: [Subtitle]
    var onChange: () -> Void

    let color1 = Color(red: 0.15, green: 0.15, blue: 0.15)
    let color2 = Color(red: 0.18, green: 0.18, blue: 0.18)
    let dividerColor = Color(red: 0.19, green: 0.19, blue: 0.19)

    var body: some View {
        LazyVStack(spacing: 0) {

            AddSubtitleView(
                addSub: { addSub(at: 0) },
                topColor: Color.clear,
                bottomeColor: color2,
                dividerColor: dividerColor,
                showDivider: true
            )

            ForEach($subs.onChange({ _ in onChange() })) { sub in
                let bg = (sub.index.wrappedValue % 2 == 0) ? color1 : color2
                let action = { addSub(at: sub.index.wrappedValue) }
                let isLastSubtitle = sub.index.wrappedValue == subs.count

                VStack {
                    SubtitleView(
                        sub: sub,
                        removeSub: removeSub,
                        bgColor: bg
                    )
                    .padding(12)

                    if (sub.index.wrappedValue % 2 == 0) {
                        AddSubtitleView(
                            addSub: action,
                            topColor: color1,
                            bottomeColor: isLastSubtitle ? Color.clear : color2,
                            dividerColor: dividerColor,
                            showDivider: !isLastSubtitle
                        )
                    } else {
                        AddSubtitleView(
                            addSub: action,
                            topColor: color2,
                            bottomeColor: isLastSubtitle ? Color.clear : color1,
                            dividerColor: dividerColor,
                            showDivider: !isLastSubtitle
                        )
                    }
                }
                .background(bg)
            }
        }
        .padding([.top], 20)
        .padding([.bottom], 50)
    }

    func addSub(at idx: Int) {
        print(idx)
        var sub = Subtitle(index: idx+1)
        if (subs.indices.contains(idx-1)) {
            let prev = subs[idx-1]
            sub.start = prev.start
            sub.end = prev.end
        }

        subs.insertSub(sub, at: idx)
        onChange()
    }

    func removeSub(at idx: Int) {
        subs.removeSub(at: idx-1)
        onChange()
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(subs: .constant([
            Subtitle(index: 1, start: Timestamp(h: 0, m: 0, s: 0, ms: 0), end: Timestamp(h: 0, m: 0, s: 1, ms: 0), caption: "Preview caption 1\n Line 2\n Line 3"),
            Subtitle(index: 2, start: Timestamp(h: 0, m: 0, s: 2, ms: 0), end: Timestamp(h: 0, m: 0, s: 4, ms: 0), caption: "Preview caption 2"),
            Subtitle(index: 3, start: Timestamp(h: 0, m: 0, s: 2, ms: 0), end: Timestamp(h: 0, m: 0, s: 4, ms: 0), caption: "Preview caption 3")
        ]),
                   onChange: {})
    }
}
