//
//  Device.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 15.02.22.
//

import Foundation

struct Device: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var multipleSliders: Bool
    var address: [Int]
}
