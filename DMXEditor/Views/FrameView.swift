//
//  TimerView.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 11.11.22.
//

import SwiftUI

struct FrameView: View {
    @Binding var slide: Slide
    @Binding var frame: Frame
    @Binding var devices: [Device]
    
    @State private var showEditor = false;
    @State var initialPoint0: CGSize = .init(width: 0.1, height: 0.2)
    @State var initialPoint1: CGSize = .init(width: 0.3, height: 0.4)
    
    var body: some View {
        VStack{
            ScrollView {
                HStack{
                    let bind = Binding<Double>(get: {
                        Double($frame.relativeTimeInSeconds.wrappedValue)
                    }, set: {
                        $frame.relativeTimeInSeconds.wrappedValue = Double(String(format:"%.2f", $0))!
                        slide.frames.sort()
                    })
                    
                    Slider(value: bind, in: 0...20){
                        Text("Delay in seconds")
                    }
                    
                    Stepper(value: bind, in: 0...255){
                        TextField("", value: bind, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .disableAutocorrection(true)
                            .frame(width: 65)
                    }
                }
                
                HStack {
                    Picker(selection: $frame.transition.mode, label: Text("Animation mode")) {
                        Text("No Animation")
                            .tag(DMXTransition.AnimationMode.none)
                        Text("Linear Animation")
                            .tag(DMXTransition.AnimationMode.linear)
                        Text("Fade in - Fade out")
                            .tag(DMXTransition.AnimationMode.fadeInFadeOut)
                        Text("Custom Bezier Animation")
                            .tag(DMXTransition.AnimationMode.bezier)
                    }
                    
                    switch(frame.transition.mode){
                        case .linear: StepPicker(steps: $frame.transition.steps)
                        case .bezier:
                            HStack{
                                StepPicker(steps: $frame.transition.steps)
                                Button("Adjust Bezier Curve"){
                                    if(frame.transition.bezierPoint0 != .zero && frame.transition.bezierPoint1 != .zero){
                                        let controlPoint0 = frame.transition.bezierPoint0
                                        let controlPoint1 = frame.transition.bezierPoint1
                                        if (controlPoint0 != .zero && controlPoint1 != .zero){
                                            initialPoint0 = .init(
                                                width: controlPoint0.x,
                                                height: controlPoint0.y)
                                            initialPoint1 = .init(
                                                width: controlPoint1.x,
                                                height: controlPoint1.y)
                                        }
                                    } else {
                                        initialPoint0 = CGSize(width: 0.4, height: 0.3)
                                        initialPoint1 = CGSize(width: 0.6, height: 0.6)
                                        frame.transition.bezierPoint0 = initialPoint0.toPoint
                                        frame.transition.bezierPoint1 = initialPoint1.toPoint
                                    }
                                    showEditor = true
                                }
                                .popover(isPresented: $showEditor, arrowEdge: .trailing){
                                    VStack{
                                        CurveEditor(controlPoint0: $frame.transition.bezierPoint0,
                                                    controlPoint1: $frame.transition.bezierPoint1,
                                                    initialPoint0: $initialPoint0,
                                                    initialPoint1: $initialPoint1)
                                        Button("Reset"){
                                            initialPoint0 = CGSize(width: 0.4, height: 0.3)
                                            initialPoint1 = CGSize(width: 0.6, height: 0.6)
                                            frame.transition.bezierPoint0 = initialPoint0.toPoint
                                            frame.transition.bezierPoint1 = initialPoint1.toPoint
                                            showEditor = false
                                        }
                                    }.padding()
                                }
                            }
                        case .fadeInFadeOut:
                            StepPicker(steps: $frame.transition.steps)
                            .onAppear(){
                                initialPoint0 = CGSize(width: 0.8, height: 0.9)
                                initialPoint1 = CGSize(width: 0.2, height: 0.1)
                                frame.transition.bezierPoint0 = initialPoint0.toPoint
                                frame.transition.bezierPoint1 = initialPoint1.toPoint
                                showEditor = false
                            }
                        default: Spacer()
                    }
                }
                
                Divider()
                    .padding(.bottom)
                
                ForEach(devices){ device in
                    VStack {
                        HStack {
                            Text(device.name)
                                .bold()
                                .font(.title3)
                            
                            Spacer()
                        }
                        
                        if (device.multipleSliders){
                            MultiSlider(
                                dataR: $frame.dmxData[device.address[0]-1],
                                dataG: $frame.dmxData[device.address[1]-1],
                                dataB: $frame.dmxData[device.address[2]-1])
                            .padding(.leading)
                        } else {
                            SingleSlider(data: $frame.dmxData[device.address[0]-1])
                                .padding(.leading)
                        }
                    } .padding(.bottom)
                }
            }
            .padding()
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(slide: .constant(Slide(number: 23, frames: [])), frame: .constant(Frame(relativeTimeInSeconds: 2.4, dmxData: [DMXData(address: 0, value: 1)])), devices: .constant(ProjectData.defaultData.settings.devices))
    }
}
