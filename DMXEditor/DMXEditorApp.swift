//
//  DMXEditorApp.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 17.02.22.
//

import SwiftUI

@main
struct DMXEditorApp: App {
    @State private var showSettings = false
    @State private var showEditor = false;
    @State var controlPoint0: RelativePoint = .init(x: 0.1, y: 0.2)
    @State var controlPoint1: RelativePoint = .init(x: 0.3, y: 0.4)
    @State var initialPoint0: CGSize = .init(width: 0.1, height: 0.2)
    @State var initialPoint1: CGSize = .init(width: 0.3, height: 0.4)
    
    var body: some Scene {
        DocumentGroup(newDocument: DMXEditorDocument()) { file in
            if(showSettings == false){
                EditView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 1000)
            } else {
                SettingsView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 900)
            }
        }
    }
}
