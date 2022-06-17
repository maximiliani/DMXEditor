//
//  GeneralSettingsView.swift
//  DMXEditor
//
//  Created by Maximilian Inckmann on 28.02.22.
//

import SwiftUI

struct GeneralSettingsView: View {
    @Binding var settings: Settings
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Text("Serveraddress (with portnumber)")
                    .frame(width:250)
                Spacer()
                TextField("http://localhost:9090", text: $settings.host)
                    .padding(.horizontal)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.horizontal)
            
            HStack{
                Text("Universe ID")
                    .frame(width:250)
                Spacer()
                TextField("", value: $settings.universe, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .onSubmit {
                        print(settings.universe)
                        if settings.universe > 65535 {
                            settings.universe = 65535
                        } else if settings.universe < 0 {
                            settings.universe = 0
                        }
                    }
            }
            .padding(.horizontal)
            
            HStack{
                VStack{
                    Text("Duration of the transition in Steps")
                        .frame(width:250)
                    Text("(16 Steps = 1s)")
                        .frame(width:250)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                Spacer()
                TextField("", value: $settings.transitionSteps, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .disableAutocorrection(true)
                    .onSubmit {
                        print(settings.transitionSteps)
                        if settings.transitionSteps < 0 {
                            settings.transitionSteps = 0
                        }
                    }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
}

struct GeneralSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(settings: .constant(ProjectData.defaultData.settings))
    }
}
