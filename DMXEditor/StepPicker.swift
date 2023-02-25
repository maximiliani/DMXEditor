//
//  StepPicker.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 25.02.23.
//

import SwiftUI

struct StepPicker: View {
    @Binding var steps: Int
    var body: some View {
        HStack{
            Text("Steps")
            NumberField(value: $steps,  min: 0, max: 255)
        }
        .help("Number of steps for the animation (0-255)")
    }
}

struct StepPicker_Previews: PreviewProvider {
    static var previews: some View {
        StepPicker(steps: .constant(42))
    }
}
