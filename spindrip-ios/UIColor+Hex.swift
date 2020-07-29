//
//  UIColor+Hex.swift
//
//  Created by Errol Cheong on 2018-11-27.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//
import UIKit

extension UIColor {
    enum HexFormat {
        case RGB
        case RGBA
        case RGBF
        case RRGGBB
        case RRGGBBAA
        case RRGGBBFF
    }
    func toHexString(_ format: HexFormat = .RRGGBBAA) -> String? {
        guard p_canProvideRGB() else { return nil }
        let maxInt = [.RGB, .RGBF, .RGBA].contains(format) ? 16 : 256
        func toInt(_ f: CGFloat) -> Int {
            return min(maxInt - 1, Int(CGFloat(maxInt) * f))
        }
        var r: CGFloat = .nan
        var g: CGFloat = .nan
        var b: CGFloat = .nan
        var a: CGFloat = .nan
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let red = toInt(r)
        let green = toInt(g)
        let blue = toInt(b)
        let alpha = toInt(a)
        switch format {
        case .RGB:
            return String(format: "#%X%X%X", red, green, blue)
        case .RGBA:
            return String(format: "#%X%X%X%X", red, green, blue, alpha)
        case .RGBF:
            return String(format: "#%X%X%XF", red, green, blue)
        case .RRGGBB:
            return String(format: "#%02X%02X%02X", red, green, blue)
        case .RRGGBBAA:
            return String(format: "#%02X%02X%02X%02X", red, green, blue, alpha)
        case .RRGGBBFF:
            return String(format: "#%02X%02X%02XFF", red, green, blue)
        }
    }
    convenience init?(hexString: String?) {
        guard let hexString = hexString else { return nil }
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        let red, green, blue, alpha: CGFloat
        switch chars.count {
        case 3:
            chars = chars + ["F"]
            fallthrough
        case 4:
            chars = chars.flatMap { [$0, $0] }
        case 6:
            chars = chars + ["F","F"]
        case 8:
            break
        default:
            return nil
        }
        red   = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
        green = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
        blue  = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
        alpha = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
        self.init(red: red, green: green, blue:  blue, alpha: alpha)
    }
}
fileprivate extension UIColor {
    func p_canProvideRGB() -> Bool {
        if let colorModel = self.cgColor.colorSpace?.model {
            switch colorModel {
            case .rgb, .monochrome:
                return true
            default:
                return false
            }
        }
        return false
    }
}
