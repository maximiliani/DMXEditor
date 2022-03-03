//
//  SingleSliderEditable.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 19.02.22.
//

import SwiftUI

struct SingleSliderEditable: View {
    @Binding var device: Device
    
    var body: some View {
        HStack{
            Text("Label: ")
            TextField("", text: $device.name)
                .textFieldStyle(.roundedBorder)
                .frame(maxWidth: 125)
            
            Text("Address: ")
            NumberField(value: $device.address[0], min: 0, max: 511)
        }
    }
}

struct SingleSliderEditable_Previews: PreviewProvider {
    static var previews: some View {
        SingleSliderEditable(device: .constant(Device(name: "Test", multipleSliders: false, address: [0])))
    }
}
