//
//  DMXData.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation

struct DMXData: Identifiable, Codable, Hashable {
    var id = UUID()
    var address: Int
    var value: Int
    
    static func getDefault() -> [DMXData]{
        var result: [DMXData] = []
        for i in 0...511{
            result.append(DMXData(address: i, value: 0))
        }
        return result
    }
}
