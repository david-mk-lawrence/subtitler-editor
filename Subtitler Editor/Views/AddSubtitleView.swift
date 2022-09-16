//
//  AddSubtitleView.swift
//  Subtitler
//
//  Created by David Lawrence on 9/11/22.
//

import Foundation
import SwiftUI

struct AddSubtitleView : View {
    var addSub: () -> Void
    var topColor: Color
    var bottomeColor: Color
    var dividerColor: Color
    var showDivider: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                topColor
                if (showDivider) {
                    Divider().background(dividerColor)
                }
                bottomeColor
            }
            .fixedSize(horizontal: false, vertical: true)

            Button(action: addSub) {
                Image(systemName: "plus.app")
            }
        }
    }
}

struct AddSubtitleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            VStack(spacing: 0) {
                Spacer()
                AddSubtitleView(
                    addSub: {},
                    topColor: Color(red: 0.15, green: 0.15, blue: 0.15),
                    bottomeColor: Color(red: 0.18, green: 0.18, blue: 0.18),
                    dividerColor: Color(red: 0.19, green: 0.19, blue: 0.19),
                    showDivider: true
                )
                Spacer()
            }

            VStack(spacing: 0) {
                Spacer()
                AddSubtitleView(
                    addSub: {},
                    topColor: Color(red: 0.15, green: 0.15, blue: 0.15),
                    bottomeColor: Color(red: 0.18, green: 0.18, blue: 0.18),
                    dividerColor: Color(red: 0.19, green: 0.19, blue: 0.19),
                    showDivider: false
                )
                Spacer()
            }
        }
    }
}
