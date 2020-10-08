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
    
    @State var dataStock: [String] = []
    
    @State var readingData: String = ""
    
    @ObservedObject var recordVM : RecordViewModel
    
    @State var isPresented: Bool = false
    
    init() {
        self.recordVM = RecordViewModel()
    }
    
    private func delete(at offsets: IndexSet){
        offsets.forEach{index in
            let recordVM = self.recordVM.records[index]
            self.recordVM.deleteRecord(recordVM)
        }
    }
    
    var body: some View {
        NavigationView{
            
            GeometryReader{ reader in
                
                VStack{
                    List{
                        ForEach(self.recordVM.records, id:\.input){ record in
                            CardView(content: record.input)
                        }.onDelete(perform: delete)
                    }.background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    
                    
                    .sheet(isPresented: $isPresented, onDismiss: {
                        print("onDismiss")
                        self.recordVM.fetchAllRecords()
                    }, content: {
                        Text("Loading")
                    })
//
                    
                    //Read Button
                    nfcButton(data: self.$data, dataStock: self.$dataStock, isPresented: self.$isPresented)
                        .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.07, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        
                    // Write Button
                    NavigationLink(destination: WriteView(isActive: self.$showWrite, data: self.$data, dataStock: self.$dataStock), isActive: self.$showWrite){
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
                .navigationBarTitle("ピットTime ~時間管理ツール~", displayMode: .inline)
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

