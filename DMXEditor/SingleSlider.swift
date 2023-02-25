//
//  SingleSlider.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 12.02.22.
//

import SwiftUI

struct SingleSlider: View {
    @Binding var data: DMXData
    
    var body: some View {
        HStack{
            Text("Address: \(data.address)")
                .padding(.trailing)
            Spacer()
            
            let bind = Binding<Double>(get: {
                Double($data.value.wrappedValue)
            }, set: {
                $data.value.wrappedValue = Int($0)
            })
            
            Slider(value: bind, in: 0...255){
                Text("Value: ")
            }
            
            Stepper(value: $data.value, in: 0...255){
                NumberField(value: $data.value, min: 0, max: 255)
            }.frame(minWidth:50)
        }
        .frame(minWidth: 400)
    }
}

struct SingleSlider_Previews: PreviewProvider {
    static var previews: some View {
        SingleSlider(data: .constant(DMXData(address: 123, value: 234)))
    }
}
