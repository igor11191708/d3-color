//
//  Color+Ext.swift
//
//
//  Created by Igor Shelopaev on 17.05.2022.
//
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

@available(iOS 14.0, macOS 12.0, *)
public extension Color {
    #if canImport(UIKit)
        var asNative: UIColor { UIColor(self) }
    #elseif canImport(AppKit)
        var asNative: NSColor { NSColor(self) }
    #endif

    /// returns values RGB and alfa channels for Color instance
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        #if canImport(UIKit)
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            asNative.getRed(&r, green: &g, blue: &b, alpha: &a)
            return (r, g, b, a)
        #elseif canImport(AppKit)

            var t = (CGFloat(), CGFloat(), CGFloat(), CGFloat())

            if let color = asNative.usingColorSpace(.deviceRGB) {
                color.getRed(&t.0, green: &t.1, blue: &t.2, alpha: &t.3)
                return t
            } else {
                let color = asNative
                color.getRed(&t.0, green: &t.1, blue: &t.2, alpha: &t.3)
                return t
            }
        #endif
    }

    /// Do a color brighter The result value must be between 0...1 Function automatically check it and clamp between 0...1
    /// Default step is 0.05
    ///   ```
    ///      let color = Color.green
    ///      color.doBrighter(k: 0.05)
    ///
    ///   ```
    /// - Parameter k: step
    /// - Returns: `Color`
    func doBrighter(k: Double? = nil) -> Color {
        let r = Double(rgba.red),
            g = Double(rgba.green),
            b = Double(rgba.blue),
            o = Double(rgba.alpha)
        let delta = k ?? 0.05

        let r_shift = (r + delta).clamped(0, 1)
        let g_shift = (g + delta).clamped(0, 1)
        let b_shift = (b + delta).clamped(0, 1)

        return Color(red: r_shift, green: g_shift, blue: b_shift, opacity: o)
    }

    /// Do a color darker The result value must be between 0...1 Function automatically check it and clamp between 0...1
    /// Default step is 0.05
    ///   ```
    ///      let color = Color.blue
    ///      color.doDarker(k: 0.05)
    ///   ```
    /// - Parameter k: step
    /// - Returns: `Color`
    func doDarker(k: Double? = nil) -> Color {
        let r = Double(rgba.red),
            g = Double(rgba.green),
            b = Double(rgba.blue),
            o = Double(rgba.alpha)
        let delta = k ?? 0.05

        let r_shift = (r - delta).clamped(0, 1)
        let g_shift = (g - delta).clamped(0, 1)
        let b_shift = (b - delta).clamped(0, 1)

        return Color(red: r_shift, green: g_shift, blue: b_shift, opacity: o)
    }
    
    init(uiColor: UIColor) {
        self.init(red: Double(uiColor.rgba.red),
                  green: Double(uiColor.rgba.green),
                  blue: Double(uiColor.rgba.blue),
                  opacity: Double(uiColor.rgba.alpha))
    }
}

// MARK: - Utilities

private extension Comparable {
    func clamped(_ a: Self, _ b: Self) -> Self {
        min(max(self, a), b)
    }
}

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (red, green, blue, alpha)
    }
}
