//
//  SettingsView.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 14.02.22.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showSettings: Bool
    @Binding var data: ProjectData
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    NavigationLink("Devices", destination: SlideEditView(data: $data))
                    NavigationLink("General", destination: GeneralSettingsView(settings: $data.settings))
                }
                
                Divider()
                
                Button(action: {
                    data.settings.devices.append(Device(name: "Single Device", multipleSliders: false, address: [data.settings.getHighestAddress() + 1]))
                }, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add single Device") .foregroundColor(Color.primary)
                    }
                })
                    .buttonStyle(.borderless)
                
                Spacer()
                
                Divider()
                
                Button(action: {
                    data.settings.devices.append(Device(name: "RGB Device", multipleSliders: true, address: [data.settings.getHighestAddress() + 1, data.settings.getHighestAddress() + 2, data.settings.getHighestAddress() + 3]))
                }, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add RGB Device") .foregroundColor(Color.primary)
                    }
                })
                    .buttonStyle(.borderless)
                
                Spacer()
            }
            
            VStack{
                Text("To start you must first configure devices.")
                
                Button(action: {
                    data.settings.devices.append(Device(name: "Single Device", multipleSliders: false, address: [data.settings.getHighestAddress() + 1]))
                }, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add single Device")
                            .foregroundColor(Color.primary)
                    }
                    .frame(minWidth: 130)
                })
                
                Button(action: {
                    data.settings.devices.append(Device(name: "RGB Device", multipleSliders: true, address: [data.settings.getHighestAddress() + 1, data.settings.getHighestAddress() + 2, data.settings.getHighestAddress() + 3]))
                }, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add RGB Device")
                            .foregroundColor(Color.primary)
                    }
                    .frame(minWidth: 130)
                })
            }
        }
        .toolbar(){
            ToolbarItem{
                Button(action: {
                    showSettings = false
                }, label: {
                    VStack{
                        Image(systemName: "square.and.pencil")
                        Text("Edit")
                    }
                    .foregroundColor(.primary)
                    .padding(.horizontal)
                })
                .padding(.horizontal)
                .buttonStyle(.borderless)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSettings: .constant(true), data: .constant(ProjectData.defaultData))
    }
}
