//
//  MultiSlider.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 12.02.22.
//

import SwiftUI

struct MultiSlider: View {
    @Binding var dataR: DMXData
    @Binding var dataG: DMXData
    @Binding var dataB: DMXData
    
    @State private var showColorPopup: Bool = false
    
    var body: some View {
        HStack {
            VStack{
                SingleSlider(data: $dataR)
                SingleSlider(data: $dataG)
                SingleSlider(data: $dataB)
            }
            RGBPicker(red: $dataR.value, green: $dataG.value, blue: $dataB.value)
                .padding()
        }.frame(minWidth: 550)
    }
}

struct MultiSlider_Previews: PreviewProvider {
    static var previews: some View {
        MultiSlider(dataR: .constant(DMXData(address: 0, value: 100)), dataG: .constant(DMXData(address: 1, value: 150)), dataB: .constant(DMXData(address: 2, value: 234)))
    }
}
