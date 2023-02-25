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
    @State private var visibility: NavigationSplitViewVisibility = .all
    @State private var showAlert: Bool = false
    @State private var showTimerAlert: Bool = false
    @State private var selectedSlide: Int? = nil
    @State private var selectedFrame: Frame? = nil
    @State private var selectedFrameIndex: Int? = nil
    @State private var activePresentation: Bool = false
    @State private var activePreview: Bool = false
    @State private var undefinedSlides: Bool = false
    @State private var highestUnavailableSlides: Int = 0
    @State private var lastDMXData:[DMXData] = DMXData.getDefault()
    @State private var activeTasks = [Task{try await Task.sleep(nanoseconds:1)}]
    
    var body: some View {
        VStack{
            NavigationSplitView(columnVisibility: $visibility){
                VStack{
                    List(selection: $selectedSlide){
                        ForEach(data.slides, id: \.self.number){ slide in
                            NavigationLink(value: slide){
                                HStack{
                                    Image(systemName: "display")
                                    Text("Slide \(slide.number)")
                                }
                            }
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
                    .navigationTitle("Slides")
                    .onCopyCommand{
                        let jsonSlide = try! JSONEncoder().encode(data.slides[selectedSlide!-1])
                        print(jsonSlide.base64EncodedString())
                        return [NSItemProvider(object: NSString(string: jsonSlide.base64EncodedString()))]
                    }
                    .onPasteCommand(of: [self.utType]){data in
                        loadPasted(from: data)
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
                        Alert(title: Text("Delete Slide" ),
                              message: Text("Are you sure you want to delete this slide?"),
                              primaryButton: .destructive(
                                Text("Delete"),
                                action: ({
                                    if(selectedSlide != nil){
                                        for i in selectedSlide!-1...data.slides.count-1{
                                            data.slides[i].number -= 1
                                        }
                                        data.slides.remove(at: selectedSlide!-1)
                                        selectedSlide = nil
                                        print("Deleted")
                                    }
                                    
                                })
                              ),
                              secondaryButton: .cancel(
                                Text("Cancel"),
                                action: ({
                                    print("Canceled")
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
            } content: {
                VStack{
                    if let selectedSlide = selectedSlide {
                        List(data.slides[selectedSlide-1].frames, id:\.id ,selection: $selectedFrame){ frame in
                            NavigationLink(value: frame) {
                                HStack{
                                    Image(systemName: "timer")
                                    Text("+ \(frame.relativeTimeInSeconds.formatted()) s")
                                }
                            }
                        }
                        .navigationTitle("Slide \(selectedSlide)")
                        .onCopyCommand{
                            if let selectedFrame{
                                let jsonFrame = try! JSONEncoder().encode(selectedFrame)
                                print(jsonFrame.base64EncodedString())
                                return [NSItemProvider(object: NSString(string: jsonFrame.base64EncodedString()))]
                            }
                            return []
                        }
                        .onPasteCommand(of: [self.utType]){data in
                            loadPasted(from: data)
                        }
                        .onDeleteCommand(perform: {showTimerAlert = true})
                        .alert(isPresented: $showTimerAlert){
                            Alert(title: Text("Delete Timer"),
                                  message: Text("Are you sure you want to delete this timer?"),
                                  primaryButton: .destructive(
                                    Text("Delete"),
                                    action: ({
                                        if(selectedFrame != nil){
                                            let frameIndex = data.slides[selectedSlide-1].frames.firstIndex(where: { f in
                                                return f.id == selectedFrame!.id
                                            })
                                            
                                            data.slides[selectedSlide-1].frames.remove(at: frameIndex!)
                                            selectedFrame = nil
                                            print("Delete")
                                        }
                                    })
                                  ),
                                  secondaryButton: .cancel(
                                    Text("Cancel")
                                  )
                            )
                        }
                        
                        Divider()
                        
                        Button(action: {addTimer()}, label: {
                            HStack{
                                Image(systemName: "plus")
                                    .foregroundColor(Color.primary)
                                Text("Add Timer") .foregroundColor(Color.primary)
                            }
                        })
                        .buttonStyle(.borderless)
                        
                        Spacer()
                    } else {
                        Text("Please select a slide!")
                    }
                }
            } detail: {
                if let selectedSlide, let selectedFrame = selectedFrame, let frameIndex = data.slides[selectedSlide-1].frames.firstIndex(where: { f in
                    return f.id == selectedFrame.id
                }){
                    FrameView(slide: $data.slides[selectedSlide-1], frame: $data.slides[selectedSlide-1].frames[frameIndex], devices: $data.settings.devices)
                } else {
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
                    .navigationSplitViewColumnWidth(min: 500, ideal: 1000)
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
    }
    
    func present() {
        Task(priority:.background){
            var last: Int = 0
            while activePresentation {
                let actual = getSlide()
                if actual != nil && actual != last && actual! <=  data.slides.count {
                    for i in activeTasks{
                        i.cancel()
                    }
                    activeTasks = []
                    print("Cancelled all Tasks")
                    for i in data.slides[actual!-1].frames{
                        activeTasks.append(Task(priority:.background){
                            let preSleepSlide: Int = getSlide()!
                            let delayInNs: UInt64 = UInt64(i.relativeTimeInSeconds*1_000_000_000)
                            if (delayInNs > 0) {
                                print("Initiating sleep for \(delayInNs) ns - Slide \(preSleepSlide)")
                                try await Task.sleep(nanoseconds: delayInNs)
                            }
                            print("Sending data with delay of \(delayInNs) ns - Slide \(preSleepSlide)")
                            sendAnimatedValues(
                                serverAddress: data.settings.host,
                                universe: data.settings.universe,
                                previousData: lastDMXData,
                                goalData: i.dmxData,
                                transition: i.transition)
                            lastDMXData = i.dmxData
                        })
                    }
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
        Task(priority:.background){
            while activePreview {
                if let selectedFrame {
                    sendValues(
                        serverAddress: data.settings.host,
                        universe: data.settings.universe,
                        data: selectedFrame.dmxData)
                }
            }
            sendValues(
                serverAddress: data.settings.host,
                universe: data.settings.universe,
                data: DMXData.getDefault())
        }
    }
    
    func addSlide(valueOfSlide: Int) {
        data.slides.append(Slide(number: data.slides.count + 1, frames: data.slides[valueOfSlide].frames))
    }
    
    func addSlide() {
        if (selectedSlide != nil && data.slides.count > selectedSlide!) {
            addSlide(valueOfSlide: selectedSlide! - 1)
        } else {
            data.slides.append(Slide(number: (data.slides.count+1), dmxData: DMXData.getDefault(), frames: []))
        }
    }
    
    func addTimer() {
        if let selectedSlide{
            let defaultDMX:[DMXData]
            if(data.slides[selectedSlide - 1].frames.count > 0 ){
                defaultDMX = data.slides[selectedSlide - 1].frames[data.slides[selectedSlide - 1].frames.count - 1].dmxData
            } else {
                defaultDMX = DMXData.getDefault()
            }
            
            let newTime = (data.slides[selectedSlide - 1].frames.max()?.relativeTimeInSeconds ?? 0) + 2.5
            
            if let selectedFrame{
                data.slides[selectedSlide - 1].frames.append(Frame(relativeTimeInSeconds: newTime, dmxData: selectedFrame.dmxData, transition: selectedFrame.transition))
            } else {
                data.slides[selectedSlide - 1].frames.append(Frame(relativeTimeInSeconds: newTime, dmxData: defaultDMX))
            }
            
            data.slides[selectedSlide - 1].frames.sort()
        }
    }
    
    func loadPasted(from array: [NSItemProvider]) {
        DispatchQueue.main.async{
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
                
                // check if Slide can be parsed
                if var parsedSlide = try? JSONDecoder().decode(Slide.self, from: Data(base64Encoded: pasteData) ?? Data()){
                    
                    parsedSlide.id = UUID()
                    
                    print(parsedSlide)
                    
                    if(parsedSlide.number == selectedSlide!){
                        data.slides.append(Slide(number: data.slides.count + 1, frames: parsedSlide.frames))
                    } else {
                        data.slides[selectedSlide!-1].frames = parsedSlide.frames
                    }
                }
                // check if Frame can be parsed
                else if var parsedData = try? JSONDecoder().decode(Frame.self, from: Data(base64Encoded: pasteData)!){
                    print(parsedData)
                    
                    parsedData.id = UUID()
                    
                    if let selectedFrame, let selectedSlide, let frameIndex = data.slides[selectedSlide-1].frames.firstIndex(where: { f in
                        return f.id == selectedFrame.id
                    }){
                        data.slides[selectedSlide - 1].frames[frameIndex].dmxData = parsedData.dmxData
                        data.slides[selectedSlide - 1].frames[frameIndex].transition = parsedData.transition
                    } else {
                        data.slides[selectedSlide! - 1].frames.append(parsedData)
                    }
                    data.slides[selectedSlide!-1].frames.sort()
                    print("Pasted")
                }
            }
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(showSettings: .constant(false), data: .constant(ProjectData.defaultData))
    }
}
