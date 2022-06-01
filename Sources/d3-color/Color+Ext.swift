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

@available(iOS 15.0, macOS 12.0, *)
public extension Color {

    #if canImport(UIKit)
        var asNative: UIColor { UIColor(self) }
    #elseif canImport(AppKit)
        var asNative: NSColor { NSColor(self) }
    #endif

    /// returns values RGB and alfa chanels for Color instance
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

    /// Do a color brighter The result value must be between 0...1 Function automaticaly check it and clamp between 0...1
    /// Default step is 0.05
    ///   ```
    ///      let color = Color.green
    ///      color.doBrighter(k: 0.05)
    ///
    ///   ```
    /// - Parameter k: step
    /// - Returns: `Color`
    func doBrighter (k: Double? = nil) -> Color {
        let r = Double(self.rgba.red),
            g = Double(self.rgba.green),
            b = Double(self.rgba.blue),
            o = Double(self.rgba.alpha)
        let delta = k ?? 0.05

        let r_shift = (r + delta).clamped(0, 1)
        let g_shift = (g + delta).clamped(0, 1)
        let b_shift = (b + delta).clamped(0, 1)

        return Color(red: r_shift, green: g_shift, blue: b_shift, opacity: o)
    }


    /// Do a color darker The result value must be between 0...1 Function automaticaly check it and clamp between 0...1
    /// Default step is 0.05
    ///   ```
    ///      let color = Color.blue
    ///      color.doDarker(k: 0.05)
    ///   ```
    /// - Parameter k: step
    /// - Returns: `Color`
    func doDarker(k: Double? = nil) -> Color {
        let r = Double(self.rgba.red),
            g = Double(self.rgba.green),
            b = Double(self.rgba.blue),
            o = Double(self.rgba.alpha)
        let delta = k ?? 0.05

        let r_shift = (r - delta).clamped(0, 1)
        let g_shift = (g - delta).clamped(0, 1)
        let b_shift = (b - delta).clamped(0, 1)

        return Color(red: r_shift, green: g_shift, blue: b_shift, opacity: o)
    }
}


// MARK: - Utilities

fileprivate extension Comparable {
    func clamped(_ a: Self, _ b: Self) -> Self {
        min(max(self, a), b)
    }
}
