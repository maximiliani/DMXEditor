//
//  Data.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 12.02.22.
//

import Foundation

struct ProjectData: Identifiable, Codable, Equatable {
    static func == (lhs: ProjectData, rhs: ProjectData) -> Bool {
        return lhs.settings == rhs.settings && lhs.slides == rhs.slides
    }
    
    var id = UUID()
    var settings: Settings
    var slides: [Slide]
    
    static var defaultData = ProjectData(settings: Settings(host: "", devices: []), slides: [])
}
