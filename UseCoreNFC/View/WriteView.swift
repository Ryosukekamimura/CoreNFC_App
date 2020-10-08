//
//  Write.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import SwiftUI




struct WriteView : View {
    
    
    @State var record = ""
    @Binding var isActive : Bool
    
    @Binding var data: String
    @Binding var dataStock : [String]

    


    
    var sessionWrite = NFCSessionWrite()
    
    
    var body: some View{
        
        Form {
            Section {
                TextField("メモを記録しよう！", text: self.$record)
            }
            
            Section{
                Button(action: {
                    self.sessionWrite.beginScanning(message: self.record)
                }, label: {
                    Text("Write")
                })
            }
            
            Section{
                Button(action: {
                    NFCReaderSession(data: self.$data, dataStock: self.$dataStock).beginScan()
                }, label: {
                    Text("Read")
                })
            }
        }
        
    }
}

