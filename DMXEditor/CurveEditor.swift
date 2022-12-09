//
//  CurveEditor.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 23.11.22.
//
import Foundation
import SwiftUI

struct CurveShape: Shape {
    let cp0, cp1: RelativePoint
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: 0, y: rect.size.height))
            p.addCurve(to: CGPoint(x: rect.size.width, y: 0),
                       control1: cp0 * rect.size,
                       control2: cp1 * rect.size)
        }
    }
}

struct ControlPointHandle: View {
    private let size: CGFloat = 20
    var body: some View {
        Circle()
            .frame(width: size, height: size)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .offset(x: -size/2, y: -size/2)
    }
}


struct CurveEditorView: View {
    @State var offsetPoint0: CGSize = .zero
    @State var offsetPoint1: CGSize = .zero
    @Binding var controlPoint0: RelativePoint
    @Binding var controlPoint1: RelativePoint
    @Binding var initialPoint0: CGSize
    @Binding var initialPoint1: CGSize
    
    var curvePoint0: RelativePoint {
        return (initialPoint0 + offsetPoint0).toPoint
    }
    
    var curvePoint1: RelativePoint {
        return (initialPoint1 + offsetPoint1).toPoint
    }
    
    var body: some View {
        
        let primaryColor   = Color.blue
        let secondaryColor = primaryColor.opacity(0.7)
        
        return GeometryReader { reader in
            
            CurveShape(cp0: self.curvePoint0, cp1: self.curvePoint1)
                .stroke(primaryColor, lineWidth: 4)
                .foregroundColor(.teal)
            
            Path { p in
                p.move(to: CGPoint(x: 0, y: 1 * reader.size.height))
                p.addLine(to: self.curvePoint0 * reader.size)
            }.stroke(secondaryColor, lineWidth: 2)
            
            Path { p in
                p.move(to: CGPoint(x: 1 * reader.size.width, y: 0))
                p.addLine(to: self.curvePoint1 * reader.size)
            }.stroke(secondaryColor, lineWidth: 2)
            
            ControlPointHandle()
                .offset(self.initialPoint0 * reader.size)
                .foregroundColor(primaryColor)
                .draggable(onChanged: { (size) in
                    self.offsetPoint0 = size / reader.size
                    self.controlPoint0 = self.curvePoint0
                })
            
            ControlPointHandle()
                .offset(self.initialPoint1 * reader.size)
                .foregroundColor(primaryColor)
                .draggable(onChanged: { (size) in
                    self.offsetPoint1 = size / reader.size
                    self.controlPoint1 = self.curvePoint1
                })
        }
        .aspectRatio(contentMode: .fit)
    }
}

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
