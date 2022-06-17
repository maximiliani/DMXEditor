//
//  Settings.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation

struct Settings: Identifiable, Codable, Equatable {
    static func == (lhs: Settings, rhs: Settings) -> Bool {
        return lhs.host == rhs.host && lhs.universe == rhs.universe && lhs.devices == rhs.devices && lhs.transitionSteps == rhs.transitionSteps
    }
    
    var id = UUID()
    var host: String
    var universe: Int = 0
    var devices: [Device]
    var transitionSteps: Int = 0
    
    func getHighestAddress() -> Int {
        var maxAddress = 0
        for device in devices {
            for i in device.address {
                if i > maxAddress {
                    maxAddress = i
                }
            }
        }
        return maxAddress
    }
}
