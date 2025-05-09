//
//  MoveType.swift
//  Gigadex
//
//  Created by Ryan Token on 5/9/25.
//

import Foundation

struct MoveType {
    let type: Type
    let details: MoveDetail

    var damageClass: DamageClass {
        switch details.damageClass.name {
        case "physical":
            return .physical
        case "special":
            return .special
        case "status":
            return .status
        default:
            return .unknown
        }
    }
}

enum DamageClass {
    case physical
    case special
    case status
    case unknown
}
