//
//  DMXAnimation.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 16.11.22.
//

import Foundation
import SwiftUI

struct DMXTransition: Codable, Identifiable, Hashable {
    
    enum AnimationMode: String, Codable {
        case none
        case linear
        case bezier
    }
    
    var id: UUID = UUID()
    var mode: AnimationMode
    var steps: Int
    
    func animate(from: [DMXData], to: [DMXData]) -> [[DMXData]]{
        if(steps > 0) {
            switch mode{
                case .none: return [to]
                case .linear: return animateLinear(from: from, to: to)
                case .bezier: return animateBezier(from: from, to: to)
            }
        } else {
            return [to]
        }
    }
    
    // MARK: Variables only necessary for Bezier animation
    var bezierPoint0: CGPoint = .zero
    var bezierPoint1: CGPoint = .zero
}

// MARK: Linear animation
extension DMXTransition {
    func animateLinear(from: [DMXData], to: [DMXData]) -> [[DMXData]]{
        var valueMatrix : [[DMXData]] = Array(repeating: DMXData.getDefault(), count: steps)
        if steps > 0 {
            for i in 0...steps-1{
                for j in 0...511 {
                    var value = from[j].value
                    if to[j].value > from[j].value {
                        value = Int(Double(from[j].value) + (Double(i)/Double(steps)) * Double(to[j].value - from[j].value))
                    } else if to[j].value < from[j].value {
                        value = Int(Double(from[j].value) - (Double(i)/Double(steps)) * Double(from[j].value - to[j].value))
                    }
                    
                    if value > 255 {
                        value = 255
                    } else if value < 0 {
                        value = 0
                    }
                    
                    valueMatrix[i][j] = DMXData(address: from[j].address, value: value)
                }
            }
        }
        valueMatrix[valueMatrix.count-1] = to
        return valueMatrix
    }
}

extension CGPoint: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

// MARK: Animation with Bezier curve
extension DMXTransition {
    func animateBezier(from: [DMXData], to: [DMXData]) -> [[DMXData]]{
        var result : [[DMXData]] = Array(repeating: DMXData.getDefault(), count: steps + 1)
        
        if (bezierPoint0 != .zero && bezierPoint1 != .zero){
            for i in 0...from.count-1 {
                let size:Double = Double(from[i].value - to[i].value)
                
                let start = CGPoint(x: 0.0, y: size)
                let end = CGPoint(x: size, y: 0.0)
            
                let p1 = CGPoint(x: bezierPoint0.x*size, y: bezierPoint0.y*size)
                let p2 = CGPoint(x: bezierPoint1.x*size, y: bezierPoint1.y*size)
                
                let bezierCurve: [CGPoint] = bPolyCubicBezier(firstPoint: start, secondPoint: p1, thirdPoint: p2, lastPoint: end, steps: steps)
                for j in 0...bezierCurve.count-1  {
                    let value = from[i].value - Int(bezierCurve[j].x)
                    result[j][i] = DMXData(address: from[i].address, value: value)
                }
            }
        }
        
        result[result.count-1] = to
        return result
    }
    
    private func bPolyCubicBezier(firstPoint: CGPoint, secondPoint: CGPoint, thirdPoint: CGPoint, lastPoint: CGPoint, steps: Int) -> [CGPoint] {
        var m = [CGPoint]()
        for t in stride(from: 0, to: 1.01, by: 1.01 / Double(steps)) {
            let s:Double = 1.0 - Double(t)
            let t2:Double = pow(t,2)
            let t3:Double = pow(t,3)
            let s2:Double = pow(s,2)
            let s3:Double = pow(s,3)
            
            let x1 = (Double(firstPoint.x) * s3) + Double(3 * secondPoint.x) * (s2 * Double(t)) + Double(3 * thirdPoint.x) * (s * t2) + (Double(lastPoint.x) * t3)
            let y1 = (Double(firstPoint.y) * s3) + Double(3 * secondPoint.y) * (s2 * Double(t)) + Double(3 * thirdPoint.y) * (s * t2) + (Double(lastPoint.y) * t3)
    
            let np = CGPoint(x: x1, y: y1)
            m.append(np)
        }
        return m
    }
}
