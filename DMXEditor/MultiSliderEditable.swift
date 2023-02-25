//
//  MultiSliderEditable.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 19.02.22.
//

import SwiftUI

struct MultiSliderEditable: View {
    @Binding var device: Device
    
    var body: some View {
        HStack{
            HStack {
                Text("Label: ")
                TextField("", text: $device.name)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 125)
            }
            
            HStack {
                HStack {
                    Text("Address: ")
                    NumberField(value: $device.address[0], min: 1, max: 511)
                }
                
                HStack {
                    Text("Address: ")
                    NumberField(value: $device.address[1], min: 1, max: 511)
                }
                
                HStack {
                    Text("Address: ")
                    NumberField(value: $device.address[2], min: 1, max: 511)
                }
            }
        }
    }
}

struct MultiSliderEditable_Previews: PreviewProvider {
    static var previews: some View {
        MultiSliderEditable(device: .constant(Device(name: "Test", multipleSliders: true, address: [0,1,2])))
    }
}
