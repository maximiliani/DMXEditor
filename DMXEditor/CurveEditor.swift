//
//  CurveEditor.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 23.11.22.
//
import Foundation
import SwiftUI

struct CurveEditor: View {
    @Binding var controlPoint0: RelativePoint
    @Binding var controlPoint1: RelativePoint
    @Binding var initialPoint0: CGSize
    @Binding var initialPoint1: CGSize
    
    var body: some View {
        VStack {
            HStack{
                Text("Value")
                    .rotationEffect(Angle(degrees: 270))
                    .fixedSize()
                
                CurveEditorView(controlPoint0: $controlPoint0, controlPoint1: $controlPoint1,  initialPoint0: $initialPoint0, initialPoint1: $initialPoint1)
                    .border(.white)
                    .frame(maxWidth: 350, maxHeight: 350)
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing)
                
                Spacer()
            }
            
            Text("Time")
        }
        .frame(width: 370, height: 350)
    }
}

struct CurveEditor_Previews: PreviewProvider {
    static var previews: some View {
        CurveEditor(controlPoint0: .constant(.zero), controlPoint1: .constant(.zero), initialPoint0: .constant(.init(width: 0.4, height: 0.3)), initialPoint1: .constant(.init(width: 0.6, height: 0.6)))
    }
}
