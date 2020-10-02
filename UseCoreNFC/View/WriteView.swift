//
//  Write.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import SwiftUI

struct WriteView : View {
    @State var record = ""
    @State private var selection = 0
    @Binding var isActive : Bool
    
    var sessionWrite = NFCSessionWrite()
    var recordType = [Payload(type: .text, pickerMsg: "Text"), Payload(type: .url, pickerMsg: "URL")]
    
    var body: some View{
        
        Form {
            Section {
                TextField("Message here.. ", text: self.$record)
                
            }
            Section {
                Picker(selection: self.$selection, label: Text("Pick a record type."), content: {
                    ForEach(0..<self.recordType.count){
                        Text(verbatim: self.recordType[$0].pickerMsg)
                    }
                })
            }
            
            Section{
                Button(action: {
                    self.sessionWrite.beginScanning(message: self.record, recordType: self.recordType[selection].type)
                }, label: {
                    Text("Write")
                })
            }
            Text("Writing View")
                .navigationBarTitle("NFC Write")
                .navigationBarItems(leading:
                                        
                Button(action: {
                    self.isActive.toggle()
                    }, label:{
                        HStack(spacing: 5){
                            Image(systemName: "chevron.left")
                            Text("back")
                        }
                    })
                )
        }
        
    }
}

struct WriteView_Preview: PreviewProvider{
    static var previews: some View{
        WriteView(isActive: .constant(false))
    }
}
