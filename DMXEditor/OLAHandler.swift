//
//  OLAHandler.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 28.02.22.
//

import Foundation

func sendValues(serverAddress: String, universe: Int = 0, data:[DMXData]) {
    var intData: [Int] = Array(repeating: 0, count: 512)
    for i in 0...data.count-1 {
        intData[data[i].address] = data[i].value
    }
    var result:String = ""
    for i in 1...511 {
        result += ",\(intData[i])"
    }
    
    let url = URL(string: "\(serverAddress)/set_dmx")
    print(url!)
    
    let script: AppleScriptRunner = AppleScriptRunner("""
do shell script "curl -d u=\(universe) -d d=\(String(intData[0]) + result) \(url!)"
""")
    script.executeSync()
    print(script.state)
    print("finished sending data")
}
