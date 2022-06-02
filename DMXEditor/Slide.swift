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

    var id = UUID()
    var number: Int
    var dmxData: [DMXData]
}

//class Slide: NSObject, Identifiable, Codable, NSItemProviderReading, NSItemProviderWriting {
//    static func == (lhs: Slide, rhs: Slide) -> Bool {
//        return lhs.number == rhs.number
//    }
//
//    var id: UUID
//    var number: Int
//    var dmxData: [DMXData]
//
//    init(number: Int, dmxData: [DMXData]) {
//        self.number = number
//        self.dmxData = dmxData
//        id = UUID()
//    }
//
//    init(number: Int, dmxData: [DMXData], id: UUID) {
//        self.number = number
//        self.dmxData = dmxData
//        self.id = id
//    }
//
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return [(kUTTypeData) as String]
//    }
//
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//
//
//        let progress = Progress(totalUnitCount: 100)
//        // 5
//
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let data = try encoder.encode(self)
//            let json = String(data: data, encoding: String.Encoding.utf8)
//            progress.completedUnitCount = 100
//            completionHandler(data, nil)
//        } catch {
//            completionHandler(nil, error)
//        }
//
//        return progress
//    }
//
//    static var readableTypeIdentifiersForItemProvider: [String] {
//        return [(kUTTypeData) as String]
//    }
//
//    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
//        let decoder = JSONDecoder()
//        do {
//            let myJSON = try decoder.decode(Slide.self, from: data)
//            return myJSON as! Self
//        } catch {
//            fatalError("Err")
//        }
//
//    }
//}


//final class SlideActionData: NSObject, Codable, NSItemProviderReading, NSItemProviderWriting {
//
//    let utType = UTType.json
//
//    var slide: Slide
//
//    init(slide: Slide) {
//        self.slide = slide
//    }
//
//    static var writableTypeIdentifiersForItemProvider: [String] {
//        return [(kUTTypeData) as String]
//    }
//
//    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
//
//
//        let progress = Progress(totalUnitCount: 100)
//        // 5
//
//        do {
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .prettyPrinted
//            let data = try encoder.encode(self)
//            let json = String(data: data, encoding: String.Encoding.utf8)
//            progress.completedUnitCount = 100
//            completionHandler(data, nil)
//        } catch {
//            completionHandler(nil, error)
//        }
//
//        return progress
//    }
//
//    static var readableTypeIdentifiersForItemProvider: [String] {
//        return [(kUTTypeData) as String]
//    }
//    // 2
//    static func object(withItemProviderData data: Data, typeIdentifier: String) throws -> Self {
//        let decoder = JSONDecoder()
//        do {
//            let myJSON = try decoder.decode(SlideActionData.self, from: data)
//            return myJSON as! Self
//        } catch {
//            fatalError("Err")
//        }
//
//    }
//
//}
