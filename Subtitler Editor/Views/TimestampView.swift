//
//  TimestampView.swift
//  Subtitler
//
//  Created by David Lawrence on 7/10/22.
//

import SwiftUI

struct TimestampView : View {
    @Binding var ts: Timestamp

    var body: some View {
        HStack {
            TimestampPartView(value: $ts.h, label: "HH", maxLength: 999, width: 50, help: "Hours")
            Text(":")
            TimestampPartView(value: $ts.m, label: "MM", maxLength: 59, width: 50, help: "Minutes")
            Text(":")
            TimestampPartView(value: $ts.s, label: "SS", maxLength: 59, width: 50, help: "Seconds")
            Text(",")
            TimestampPartView(value: $ts.ms, label: "mmm", maxLength: 999, width: 65, help: "Milliseconds")
        }.fixedSize()
    }
}

struct TimestampView_Previews: PreviewProvider {
    static var previews: some View {
        TimestampView(ts: .constant(
            Timestamp(h: 0, m: 0, s: 0, ms: 0)
        ))
    }
}
