//
//  Utils.swift
//  Gigadex
//
//  Created by Ryan Token on 5/8/25.
//

import Foundation

class Utils {
    static func getId(from url: String) -> String {
        let cleanUrl = url.hasSuffix("/") ? String(url.dropLast()) : url
        let components = cleanUrl.components(separatedBy: "/")
        return components.last ?? ""
    }
}
