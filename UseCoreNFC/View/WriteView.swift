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
    
    @Binding var data: String
    
    
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
                nfcButton(data: self.$data)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
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

