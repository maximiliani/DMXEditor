//
//  DMXEditorDocument.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 17.02.22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static let dmxDoc = UTType(exportedAs: "de.inckmann.dmxDoc")
}

struct DMXEditorDocument: FileDocument{
    var documentData: ProjectData
    static var readableContentTypes: [UTType] { [.dmxDoc] }
    
    init(){
        documentData = ProjectData.defaultData
    }
    
    init(initialData: ProjectData){
        documentData = initialData
    }
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let result = try? JSONDecoder().decode(ProjectData.self, from: data)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        documentData = result;
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(documentData)
        return .init(regularFileWithContents: data)
    }
}
