//
//  Item.swift
//  MusicBox
//
//  Created by Marcelo Napoleao Sampaio on 2024-04-10.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
