//
//  RGBPicker.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 12.02.22.
//

import SwiftUI

struct RGBPicker: View {
    @State private var color: Color = Color.red
    @Binding var red: Int
    @Binding var green: Int
    @Binding var blue: Int
    
    var body: some View {
        VStack{
            ColorPicker("", selection: $color)
                .controlSize(.large)
                .onChange(of: color) { [color] newState in
                    let rCol = color.cgColor?.components?[0]
                    let gCol = color.cgColor?.components?[1]
                    let bCol = color.cgColor?.components?[2]
                    
                    let r = Int((rCol ?? 0) * 255)
                    let g = Int((gCol ?? 0) * 255)
                    let b = Int((bCol ?? 0) * 255)
                    
                    red = r
                    green = g
                    blue = b
                }

            Text("RGB \(red) \(green) \(blue)")
                .foregroundColor(.teal)
            Text("Hex \(String(format:"%02X", red))\(String(format:"%02X", green))\(String(format:"%02X", blue))")
                .foregroundColor(.teal)
        }
        .padding()
        .background(Color(red: (Double($red.wrappedValue) / 255), green: (Double($green.wrappedValue) / 255), blue: (Double($blue.wrappedValue) / 255)))
        .cornerRadius(10)
        .frame(maxWidth: 175, maxHeight: 75)
    }
}

struct RGBPicker_Previews: PreviewProvider {
    static var previews: some View {
        RGBPicker(red: .constant(23), green: .constant(123), blue: .constant(234))
    }
}
