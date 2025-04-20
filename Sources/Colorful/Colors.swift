//
//  Utils.swift
//  Colorful
//
//  Created by wong on 4/21/25.
//

import AppKit
import SwiftUICore

extension Color {
    var toNSColor: NSColor? {
        let cgColor = NSColor(self).cgColor
        return NSColor(cgColor: cgColor)
    }
    var alpha: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 1
        nsColor?.getHue(nil, saturation: nil, brightness: nil, alpha: &value)
        return value
    }
    var hue: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(&value, saturation: nil, brightness: nil, alpha: nil)
        return value
    }
    var saturation: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(nil, saturation: &value, brightness: nil, alpha: nil)
        return value
    }
    var brightness: CGFloat {
        let nsColor = self.toNSColor
        var value: CGFloat = 0
        nsColor?.getHue(nil, saturation: nil, brightness: &value, alpha: nil)
        return value
    }
}
