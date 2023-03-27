//
//  Haptics.swift
//  Games
//
//  Created by Jack Finnis on 18/03/2023.
//

import UIKit

struct Haptics {
    static func tap() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
