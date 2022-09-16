//
//  TimestampPartView.swift
//  Subtitler
//
//  Created by David Lawrence on 9/5/22.
//

import Foundation
import SwiftUI
import Combine

struct TimestampPartView : View {
    @Binding var value: Int
    var label: String
    var maxLength: Int
    var width: CGFloat = 20
    var help: String

    @State var valid: Bool = true

    var body: some View {
        HStack {
            TextField(label, value: $value, format: .number)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.trailing)
                .help(NSLocalizedString(help, comment: ""))
                .onReceive(Just(value), perform: validate)
                .onAppear(perform: setup)
                .frame(width: width)
        }
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(
            valid ? .clear : .red, lineWidth: 2))
    }

    func setup() {
        validate(val: value)
    }

    func validate(val: Int) {
        let newVal = val.clamped(to: 0...maxLength)
        if newVal != val {
            valid = false
        } else {
            valid = true
        }
    }
}

struct TimestampPartView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TimestampPartView(value: .constant(20), label: "HH", maxLength: 59, width: 50, help: "Hours", valid: true)
            TimestampPartView(value: .constant(100), label: "HH", maxLength: 59, width: 65, help: "Hours", valid: false)
        }
    }
}
