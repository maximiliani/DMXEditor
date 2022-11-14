//
//  Slide.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct Slide: Identifiable, Codable, Hashable {
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.number == rhs.number
    }
    
    enum DeCodingKeys: String, CodingKey{
        case id
        case number
        case dmxData
        case frames
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: DeCodingKeys.self)
        id = try values.decode(UUID.self, forKey: .id)
        number = try values.decode(Int.self, forKey: .number)
        frames = try values.decodeIfPresent([Frame].self, forKey: .frames) ?? []
        frames.sort()
        if let data0 = try values.decodeIfPresent([DMXData].self, forKey: .dmxData){
            frames.append(Frame(relativeTimeInSeconds: 0, dmxData: data0))
        }
        
    }
    
    init(number: Int, dmxData: [DMXData]?, frames: [Frame]?){
        self.number = number
            
        if(frames != nil) {
            self.frames = frames!
        } else {
            self.frames = []
        }
        
        if(dmxData != nil) {
//            self.dmxData = dmxData!
            self.frames.append(Frame(relativeTimeInSeconds: 0, dmxData: dmxData!))
        } else {
            self.frames.append(Frame(relativeTimeInSeconds: 0, dmxData: DMXData.getDefault()))
//            self.dmxData = DMXData.getDefault()
        }
        
        self.frames.sort()
    }
    
    init(number: Int, frames: [Frame]?){
        self.number = number
            
        if(frames != nil) {
            self.frames = frames!
        } else {
            self.frames = [Frame(relativeTimeInSeconds: 0, dmxData: DMXData.getDefault())]
        }
        
        self.frames.sort()
    }
    
    var id = UUID()
    var number: Int
//    var dmxData: [DMXData]
    var frames: [Frame]
}
