//
//  Delay.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 11.11.22.
//

import Foundation

struct Frame: Identifiable, Codable, Comparable, Hashable {
    static func == (lhs: Frame, rhs: Frame) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Frame, rhs: Frame) -> Bool {
        return lhs.relativeTimeInSeconds < rhs.relativeTimeInSeconds
    }
    
    enum CodingKeys: String, CodingKey{
        case id
        case relativeTimeInSeconds
        case dmxData
        case transition
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        relativeTimeInSeconds = try values.decode(Double.self, forKey: .relativeTimeInSeconds)
        dmxData = try values.decode([DMXData].self, forKey: .dmxData)
        transition = try values.decodeIfPresent(DMXTransition.self, forKey: .transition) ?? DMXTransition(mode: .fadeInFadeOut, steps: 32)
    }
    
    init(relativeTimeInSeconds: Double, dmxData: [DMXData]){
        self.relativeTimeInSeconds = relativeTimeInSeconds
        self.dmxData = dmxData
        transition = DMXTransition(mode: .fadeInFadeOut, steps: 32)
    }
    
    init(relativeTimeInSeconds: Double, dmxData: [DMXData], transition: DMXTransition){
        self.relativeTimeInSeconds = relativeTimeInSeconds
        self.dmxData = dmxData
        self.transition = transition
    }
    
    var id = UUID()
    var relativeTimeInSeconds: Double
    var dmxData: [DMXData]
    var transition: DMXTransition
}
