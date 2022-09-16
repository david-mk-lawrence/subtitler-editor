//
//  Binding.swift
//  Subtitler
//
//  Created by David Lawrence on 7/10/22.
//

import Foundation
import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
            drawsBackground = true
        }

    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        if self.count < toLength {
          return String(repeatElement(character, count: toLength - self.count)) + self
        }
        return self
      }
}

extension Character {
    static let zeroWidthSpace1 = Self(.init(0x200B)!)
    static let zeroWidthSpace2 = Self(.init(0xFEFF)!)

    var isZeroWidthSpace: Bool { self == .zeroWidthSpace1 || self == .zeroWidthSpace2 }
}

extension Bool {
    var negated: Bool { !self }
}
