//
//  EditView.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 14.02.22.
//

import SwiftUI
import UniformTypeIdentifiers

struct EditView: View {
    let utType = UTType.utf8PlainText
    @Binding var showSettings: Bool
    @Binding var data: ProjectData
    @State private var showAlert: Bool = false
    @State private var selectedSlide: Int? = nil
    @State private var activePresentation: Bool = false
    @State private var activePreview: Bool = false
    @State private var undefinedSlides: Bool = false
    @State private var highestUnavailableSlides: Int = 0
    
    var body: some View {
        NavigationView{
            VStack{
                List(selection: $selectedSlide){
                    ForEach($data.slides, id: \.self.number){ slide in
                        NavigationLink("Slide \(slide.wrappedValue.number)", destination: SlideView(slide: slide, devices: $data.settings.devices))
                    }
                    .onMove { indices, destination in
                        let startIndex = indices.first!
                        var destinationIndex:Int = destination
                        
                        if startIndex > destinationIndex {
                            for i in destinationIndex...startIndex{
                                data.slides[i].number = i + 2
                            }
                        } else if startIndex < destinationIndex {
                            if destination > 0 {
                                destinationIndex = destination - 1
                            }
                            for i in startIndex+1...destinationIndex{
                                data.slides[i].number = i
                            }
                        }
                        
                        data.slides[startIndex].number = destinationIndex + 1
                        data.slides.move(fromOffsets: indices, toOffset: destination)
                        
                    }
                }
                .onCopyCommand{
                    let jsonSlide = try! JSONEncoder().encode(data.slides[selectedSlide!-1])
                    print(jsonSlide.base64EncodedString())
                    return [NSItemProvider(object: NSString(string: jsonSlide.base64EncodedString()))]
                }
                .onPasteCommand(of: [self.utType]){data in
                    loadPastedSlide(from: data)
                }
                .onDeleteCommand(perform: {showAlert = true})
                .onMoveCommand{ i in
                    if i == MoveCommandDirection.down {
                        if selectedSlide! > 0{
                            selectedSlide! -= 1
                        } else {
                            selectedSlide! = 0
                        }
                    } else if i == MoveCommandDirection.up {
                        if selectedSlide! < data.slides.count - 1{
                            selectedSlide! += 1
                        } else {
                            selectedSlide! = data.slides.count - 1
                        }
                    }
                }
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
                    activePreview.toggle()
                    activePresentation = false
                    preview()
                }, label: {
                    VStack{
                        Image(systemName: activePreview ? "stop.fill" : "play.fill")
                        Text(activePreview ? "Stop preview" : "Start preview")
                    }
                    .foregroundColor(.primary)
                })
                .padding(.trailing)
                .buttonStyle(.borderless)
            }
            
            ToolbarItem{
                Button(action: {
                    activePresentation.toggle()
                    activePreview = false
                    present()
                }, label: {
                    VStack{
                        Image(systemName: activePresentation ? "stop.fill" : "play.fill")
                        Text(activePresentation ? "Stop presentation" : "Start presentation")
                    }
                    .foregroundColor(.primary)
                })
                .padding(.trailing)
                .buttonStyle(.borderless)
            }
            
            ToolbarItem{
                Button(action: {
                    showSettings = true
                }, label: {
                    VStack{
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .foregroundColor(.primary)
                })
                .padding(.trailing)
                .buttonStyle(.borderless)
            }
        }
        .alert(isPresented: $undefinedSlides){
            Alert(title: Text("No data available from slide \(data.slides.count + 1) to \(highestUnavailableSlides)"),
                  message: Text("As there are no entries for the slides so far, it is recommended to add entries for these slides to the editor. Otherwise the last defined value will be lasting until the end but is not controllable by the presentation."),
                  primaryButton: .cancel(
                    Text("+ Add slides to editor"),
                    action: {
                        for i in data.slides.count...highestUnavailableSlides-1 {
                            print("Adding Slide \(i)")
                            if data.slides.count >= 1 {
                                addSlide(valueOfSlide: data.slides.count)
                            } else {
                                addSlide()
                            }
                        }
                    }),
                  secondaryButton: .cancel())
        }
    }
    
    func present() {
        DispatchQueue.global(qos: .background).async {
            var last: Int = 1
            while activePresentation {
                let actual = getSlide()
                if actual != nil && actual != last && actual! <=  data.slides.count{
                    sendValues(
                        serverAddress: data.settings.host,
                        universe: data.settings.universe,
                        previousData: data.slides[last-1].dmxData,
                        goalData: data.slides[actual!-1].dmxData,
                        amountSteps: data.settings.transitionSteps,
                        duration: data.settings.transitionDuration)
                    last = actual!
                } else if actual != nil && actual! > data.slides.count && highestUnavailableSlides != actual! {
                    highestUnavailableSlides = actual!
                    print("No value for slide \(actual!) available!")
                }
            }
            sendValues(
                serverAddress: data.settings.host,
                universe: data.settings.universe,
                data: DMXData.getDefault())
            if highestUnavailableSlides > 0 {
                undefinedSlides = true
            }
        }
    }
    
    func preview() {
        DispatchQueue.global(qos: .background).async {
            while activePreview {
                if selectedSlide != nil {
                    sendValues(
                        serverAddress: data.settings.host,
                        universe: data.settings.universe,
                        data: data.slides[selectedSlide!-1].dmxData)
                }
            }
            sendValues(
                serverAddress: data.settings.host,
                universe: data.settings.universe,
                data: DMXData.getDefault())
        }
    }
    
    func addSlide(valueOfSlide: Int) {
        data.slides.append(Slide(number: (data.slides.count+1), dmxData: data.slides[valueOfSlide-1].dmxData))
    }
    
    func addSlide() {
        if (selectedSlide != nil && data.slides.count > selectedSlide!) {
            addSlide(valueOfSlide: selectedSlide!)
        } else {
            data.slides.append(Slide(number: (data.slides.count+1), dmxData: DMXData.getDefault()))
        }
    }
    
    func loadPastedSlide(from array: [NSItemProvider]) {
        guard let lastItem = array.last else {
            assertionFailure("Nothing to paste")
            return
        }
        lastItem.loadDataRepresentation(forTypeIdentifier: utType.identifier) {
            (pasteData, error) in
            guard error == nil else {
                assertionFailure("Could not load data: \(error.debugDescription)")
                return
            }
            guard let pasteData = pasteData else {
                assertionFailure("Could not load data")
                return
            }
            let parsedData = try! JSONDecoder().decode(Slide.self, from: Data(base64Encoded: pasteData)!)
            print(parsedData)
            if(parsedData.number == selectedSlide!){
                data.slides.append(Slide(number: data.slides.count + 1, dmxData:  parsedData.dmxData))
            } else {
                data.slides[selectedSlide!-1].dmxData = parsedData.dmxData
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(showSettings: .constant(false), data: .constant(ProjectData.defaultData))
    }
}
