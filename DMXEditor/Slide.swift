//
//  Slide.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation
import UniformTypeIdentifiers

struct Slide: Identifiable, Codable, Hashable {
    
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.number == rhs.number
    }
    
    var id = UUID()
    var number: Int
    var dmxData: [DMXData]
}
