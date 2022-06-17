//
//  KeynoteHandler.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 22.02.22.
//

import Foundation

var script: AppleScriptRunner = AppleScriptRunner("""
property selectedSlide : 0
delay 0.5
tell application "Keynote"
    set selectedSlide to slide number of current slide of front document
end tell
return selectedSlide
""")

func getSlide() -> Int?{
    script.executeSync()
    switch script.state {
    case .running:
        break
    case .complete(let result):
        return Int(result.int32Value)
    case .idle:
        break
    case .error(let error):
        print(error)
    }
    return nil
}
