//
//  ContentView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/09/30.
//

import SwiftUI
import CoreNFC


struct ContentView: View {
    @State var data = ""
    @State var showWrite = false
    let holder = "記録がここに表示されます"
    
    var body: some View {
        NavigationView{
            
            GeometryReader{ reader in
                
                VStack(spacing: 30){
                    ZStack(alignment: .topLeading){
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 4))
                        
                        Text(self.data.isEmpty ? self.holder : self.data)
                            .foregroundColor(self.data.isEmpty ? .gray : .black)
                            .padding()
                        
                    }.frame(height: reader.size.height * 0.4)
                    
                    
                    nfcButton(data: self.$data)
                        .frame(height: reader.size.height * 0.07)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // Write Button
                    NavigationLink(destination: WriteView(isActive: self.$showWrite, data: self.$data), isActive: self.$showWrite){
                        Button(action: {
                            self.showWrite.toggle()
                        }, label: {
                            Text("NFCに書き込み")
                                .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.07)
                        }).foregroundColor(.white)
                        .background(Color(.black))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    
                    Spacer()
                }
                .navigationBarTitle("NFCで時間管理", displayMode: .inline)
                .padding(.top, 20)
            }
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

