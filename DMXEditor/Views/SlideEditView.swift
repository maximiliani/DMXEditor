//
//  SlideEditView.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 20.02.22.
//

import SwiftUI

struct SlideEditView: View {
    @Binding var data: ProjectData
    @State private var showAlert: Bool = false
    @State private var offset: IndexSet?
    
    var body: some View {
        List(){
            ForEach($data.settings.devices){ device in
                if (device.multipleSliders.wrappedValue){
                    MultiSliderEditable(device: device)
                } else {
                    SingleSliderEditable(device: device)
                }
            }.onDelete(perform: delete)
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Delete Device without data"),
                  message: Text("Are you sure you want to delete the device? The corresponding data won`t be deleted."),
                  primaryButton: .destructive(
                    Text("Delete"),
                    action: ({
                        if (offset != nil) {
                            data.settings.devices.remove(atOffsets: offset!)
                        }
                        print("Delete")
                    })
                  ),
                  secondaryButton: .cancel(
                    Text("Cancel"),
                    action: ({
                        print("Cancel")
                    })
                  )
                  
            )
        }
    }
    
    func delete(at offsets: IndexSet) {
        showAlert = true
        offset = offsets
    }
}

struct SlideEditView_Previews: PreviewProvider {
    static var previews: some View {
        SlideEditView(data: .constant(.defaultData))
    }
}
