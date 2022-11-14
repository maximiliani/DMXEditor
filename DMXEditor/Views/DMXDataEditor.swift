////
////  DMXDataEditor.swift
////  DMXEditor
////
////  Created by Maximilian Inckmann on 11.11.22.
////
//
//import SwiftUI
//
//struct DMXDataEditor: View {
//    @Binding var dmxData: [DMXData]
//    @Binding var devices: [Device]
//    
//    var body: some View {
//        ScrollView {
//            ForEach(devices){ device in
//                VStack {
//                    HStack {
//                        Text(device.name)
//                            .bold()
//                            .font(.title3)
//                        
//                        Spacer()
//                    }
//                    
//                    if (device.multipleSliders){
//                        MultiSlider(
//                            dataR: $dmxData[device.address[0]-1],
//                            dataG: $dmxData[device.address[1]-1],
//                            dataB: $dmxData[device.address[2]-1])
//                        .padding(.leading)
//                    } else {
//                        SingleSlider(data: $dmxData[device.address[0]-1])
//                            .padding(.leading)
//                    }
//                } .padding(.bottom)
//            }
//        }
//        .padding()
//    }
//}
//
//struct DMXDataEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        DMXDataEditor(dmxData: .constant([DMXData(address: 0, value: 1)]), devices: .constant(ProjectData.defaultData.settings.devices))
//        
//    }
//}
