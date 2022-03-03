//
//  DMXEditorApp.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 17.02.22.
//

import SwiftUI

@main
struct DMXEditorApp: App {
    @State private var showSettings = false;
    
    var body: some Scene {
        DocumentGroup(newDocument: DMXEditorDocument()) { file in
            if(showSettings == false){
                EditView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 700)
            } else {
                SettingsView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 700)
            }
        }
    }
}
