//
//  TimerView.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 11.11.22.
//

import SwiftUI

struct TimerView: View {
    @Binding var slide: Slide
    @Binding var frame: Frame
    @Binding var devices: [Device]
    
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
            
//            DMXDataEditor(dmxData: $delay.dmxData, devices: $devices)
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(slide: .constant(Slide(number: 23, frames: [])), frame: .constant(Frame(relativeTimeInSeconds: 2.4, dmxData: [DMXData(address: 0, value: 1)])), devices: .constant(ProjectData.defaultData.settings.devices))
    }
}
