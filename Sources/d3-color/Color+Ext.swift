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

// Extension for Color to support conversions and utility methods
@available(iOS 15.0, macOS 12.0, tvOS 16.0, watchOS 7.0, *)
public extension Color {

    // Converts Color to the platform-specific color representation
    #if canImport(UIKit)
    var asNative: UIColor { UIColor(self) }
    #elseif canImport(AppKit)
    var asNative: NSColor { NSColor(self) }
    #endif

    /// Returns the RGB and alpha channel values for the Color instance
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

    /// Makes the color brighter by a specified step. The result is clamped between 0 and 1.
    /// - Parameter k: The step by which to brighten the color. Default is 0.05.
    /// - Returns: A new `Color` instance with adjusted brightness.
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

    /// Makes the color darker by a specified step. The result is clamped between 0 and 1.
    /// - Parameter k: The step by which to darken the color. Default is 0.05.
    /// - Returns: A new `Color` instance with adjusted brightness.
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

    #if canImport(UIKit)
    /// Initializes a SwiftUI Color from a UIColor instance.
    /// - Parameter uiColor: The UIColor instance.
    init(uiColor: UIColor) {
        self.init(red: Double(uiColor.rgba.red),
                  green: Double(uiColor.rgba.green),
                  blue: Double(uiColor.rgba.blue),
                  opacity: Double(uiColor.rgba.alpha))
    }
    #endif
}

// MARK: - Utilities

// Extension to clamp Comparable values within a specified range
fileprivate extension Comparable {
    func clamped(_ a: Self, _ b: Self) -> Self {
        min(max(self, a), b)
    }
}

#if canImport(UIKit)
// Extension to get the RGBA components of a UIColor
fileprivate extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}
#endif
