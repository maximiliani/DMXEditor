//
//  OLAHandler.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 28.02.22.
//

import Foundation

func sendAnimatedValues(serverAddress: String, universe: Int = 0, previousData: [DMXData], goalData:[DMXData], transition: DMXTransition) {
    let valueMatrix = transition.animate(from: previousData, to: goalData)
    for i in valueMatrix {
        var values: [Int] = []
        for j in i {
            values.append(j.value)
        }
        print(values)
        sendDataToServer(universe: universe, data: values, serverAddress: serverAddress)
    }
    print("Finished sending data")
    //    print(valueMatrix)
}

func sendValues(serverAddress: String, universe: Int = 0, previousData: [DMXData], goalData:[DMXData], amountSteps: Int) {
    var valueMatrix : [[Int]] = Array(repeating: Array(repeating: 0, count: 512), count: amountSteps+1)
    if amountSteps > 0 {
        for i in 0...amountSteps-1{
            for j in 0...511 {
                if goalData[j].value > previousData[j].value {
                    valueMatrix[i][j] = Int(Float(previousData[j].value) + (Float(i)/Float(amountSteps)) * Float(goalData[j].value - previousData[j].value))
                } else if goalData[j].value < previousData[j].value {
                    valueMatrix[i][j] = Int(Float(previousData[j].value) - (Float(i)/Float(amountSteps)) * Float(previousData[j].value - goalData[j].value))
                } else {
                    valueMatrix[i][j] = previousData[j].value
                }
                
                if valueMatrix[i][j] > 255 {
                    valueMatrix[i][j] = 255
                } else if valueMatrix[i][j] < 0 {
                    valueMatrix[i][j] = 0
                }
            }
            sendDataToServer(universe: universe, data: valueMatrix[i], serverAddress: serverAddress)
        }
    }
    for j in 0...511 {
        valueMatrix[amountSteps][j] = goalData[j].value
    }
    sendDataToServer(universe: universe, data: valueMatrix[amountSteps], serverAddress: serverAddress)
    print("Finished sending data")
    print(valueMatrix)
}

func sendValues(serverAddress: String, universe: Int = 0, data:[DMXData]) {
    var intData: [Int] = Array(repeating: 0, count: 512)
    for i in 0...data.count-1 {
        intData[data[i].address] = data[i].value
    }
    sendDataToServer(universe: universe, data: intData, serverAddress: serverAddress)
}

func sendDataToServer(universe: Int, data: [Int], serverAddress: String){
    print(data[0])
    var result:String = "\(data[0])"
    for i in 1...511 {
        result += ",\(data[i])"
    }
    
    let url = URL(string: "\(serverAddress)/set_dmx")
    
    let script: AppleScriptRunner = AppleScriptRunner("""
    do shell script "curl -d u=\(universe) -d d=\(result) \(url!)"
    """)
    script.executeSync()
    if type(of: script.state) == AppleScriptRunner.Error.self {
        print(script.state)
    }
}
