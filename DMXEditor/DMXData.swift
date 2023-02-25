//
//  DMXData.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation

struct DMXData: Identifiable, Codable, Hashable {
    var id = UUID()
    var address: Int { didSet {
        if(address > 511){
            address = 511
        } else if (address < 1){
            address = 1
        }
    }}
    var value: Int { didSet {
        if(value > 255){
            value = 255
        } else if (value < 0){
            value = 0
        }
    }}
    
    static func getDefault() -> [DMXData]{
        var result: [DMXData] = []
        for i in 0...511{
            result.append(DMXData(address: i, value: 0))
        }
        return result
    }
}
