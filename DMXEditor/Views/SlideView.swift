//
//  SlideView.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 14.02.22.
//

import SwiftUI

struct SlideView: View {
    @Binding var slide: Slide
    @Binding var devices: [Device]
    
    var body: some View {
        ScrollView {
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
                            dataR: $slide.dmxData[device.address[0]-1],
                            dataG: $slide.dmxData[device.address[1]-1],
                            dataB: $slide.dmxData[device.address[2]-1])
                        .padding(.leading)
                    } else {
                        SingleSlider(data: $slide.dmxData[device.address[0]-1])
                            .padding(.leading)
                    }
                } .padding(.bottom)
            }
        }
        .padding()
    }
}

struct SlideView_Previews: PreviewProvider {
    static var previews: some View {
        SlideView(slide: .constant(Slide(number: 1, dmxData: [DMXData(address: 0, value: 1)])), devices: .constant(ProjectData.defaultData.settings.devices))
    }
}
