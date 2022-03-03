//
//  NumberField.swift
//  DMXEditorForKeynote
//
//  Created by Maximilian Inckmann on 12.02.22.
//

import SwiftUI

struct NumberField: View {
    @Binding var value: Int
    @State var min:Int?
    @State var max:Int?
    
    var body: some View {
        TextField("", value: $value, format: .number)
            .textFieldStyle(.roundedBorder)
            .frame(width: 45)
            .disableAutocorrection(true)
            .onSubmit {
                print(value)
                if (max != nil && min != nil) {
                    if value > max! {
                        value = max!
                    } else if value < min! {
                        value = min!
                    }
                }
            }
    }
}

struct NumberField_Previews: PreviewProvider {
    static var previews: some View {
        NumberField(value: .constant(200), min: 0, max: 511)
    }
}
