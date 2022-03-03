//
//  EditView.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 14.02.22.
//

import SwiftUI

struct EditView: View {
    @Binding var showSettings: Bool
    @Binding var data: ProjectData
    @State private var showAlert: Bool = false
    @State private var selectedSlide: Int? = nil
    @State private var activePresentation: Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                List(selection: $selectedSlide){
                    ForEach($data.slides, id: \.self.number){ slide in
                        NavigationLink("Slide \(slide.wrappedValue.number)", destination: SlideView(slide: slide, devices: $data.settings.devices))
                    }
                }
                .onDeleteCommand(perform: {showAlert = true})
                .alert(isPresented: $showAlert){
                    Alert(title: Text((selectedSlide == data.slides.count) ? "Delete Slide" : "Delete Content"),
                          message: Text((selectedSlide == data.slides.count) ? "Are you sure you want to delete this slide?" : "Are you sure you want to delete the content of this slide?"),
                          primaryButton: .destructive(
                            Text("Delete"),
                            action: ({
                                if(selectedSlide != nil){
                                    if (selectedSlide == data.slides.count){
                                        data.slides.remove(at: selectedSlide!-1)
                                    } else {
                                        data.slides[selectedSlide! - 1 ].dmxData = DMXData.getDefault()
                                    }
                                }
                                selectedSlide = nil
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
                
                Divider()
                
                Button(action: {addSlide()}, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add Slide") .foregroundColor(Color.primary)
                    }
                })
                    .buttonStyle(.borderless)
                Spacer()
            }
            
            VStack{
                Text("To start you must first create slides and configure devices.")
                
                Button(action: {addSlide()}, label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color.primary)
                        Text("Add Slide")
                            .foregroundColor(Color.primary)
                    }
                    .frame(minWidth: 110)
                })
                
                Button(action: {
                    showSettings = true
                }, label: {
                    HStack{
                        Image(systemName: "gear")
                            .foregroundColor(Color.primary)
                        Text("Go to Settings")
                            .foregroundColor(Color.primary)
                    }
                    .frame(minWidth: 110)
                })
            }
        }
        .toolbar(){
            ToolbarItem{
                Button(action: {
                    activePresentation.toggle()
                    present()
                }, label: {
                    HStack{
                        Image(systemName: activePresentation ? "stop.fill" : "play.fill")
                            .foregroundColor(Color.primary)
                            .font(.title3)
                        Text(activePresentation ? "Stop" : "Start")
                            .fontWeight(.medium)
                            .foregroundColor(Color.primary)
                            .font(.title3)
                    }
                })
                    .padding(.trailing)
                    .buttonStyle(.borderless)
            }
            
            ToolbarItem{
                Button(action: {
                    showSettings = true
                }, label: {
                    HStack{
                        Image(systemName: "gear")
                            .foregroundColor(Color.primary)
                            .font(.title3)
                        Text("Settings")
                            .fontWeight(.medium)
                            .foregroundColor(Color.primary)
                            .font(.title3)
                    }
                })
                    .padding(.trailing)
                    .buttonStyle(.borderless)
            }
        }
    }
    
    func present() {
        DispatchQueue.global(qos: .background).async {
            var last: Int = 0
            while activePresentation {
                let actual = getSlide()
                if actual != nil && actual != last{
                    last = actual!
                    print("slide \(last)")
                    sendValues(
                        serverAddress: data.settings.host,
                        universe: data.settings.universe,
                        data: data.slides[last-1].dmxData)
                }
            }
        }
    }
    
    func addSlide() {
        if (selectedSlide != nil && data.slides.count > selectedSlide!) {
            data.slides.append(Slide(number: (data.slides.count+1), dmxData: data.slides[selectedSlide! - 1].dmxData))
        } else {
            data.slides.append(Slide(number: (data.slides.count+1), dmxData: DMXData.getDefault()))
        }
        
//        if data.slides.count - 1 >= 0{
//            data.slides.append(Slide(number: (data.slides.count+1), dmxData: data.slides[data.slides.count - 1].dmxData))
//        } else {
//            data.slides.append(Slide(number: (data.slides.count+1), dmxData: DMXData.getDefault()))
//        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(showSettings: .constant(false), data: .constant(ProjectData.defaultData))
    }
}
