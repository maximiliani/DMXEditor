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
    @State private var initialPopup = false;
    
    var body: some Scene {
        DocumentGroup(newDocument: DMXEditorDocument()) { file in
            if(showSettings == false){
                EditView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 700)
                    .popover(isPresented: $initialPopup, content: {
                        VStack{
                            Text("HI")
                        }
                    })
            } else {
                SettingsView(showSettings: $showSettings, data: file.$document.documentData)
                    .frame(minWidth: 700)
            }
        }
    }
}
