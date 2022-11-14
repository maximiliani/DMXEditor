//
//  Delay.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 11.11.22.
//

import Foundation

struct Frame: Identifiable, Codable, Hashable, Comparable {
    static func < (lhs: Frame, rhs: Frame) -> Bool {
        return lhs.relativeTimeInSeconds < rhs.relativeTimeInSeconds
    }
    
    var id = UUID()
    var relativeTimeInSeconds: Double
    var dmxData: [DMXData]
}
