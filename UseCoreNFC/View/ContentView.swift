//
//  ContentView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/09/30.
//

import SwiftUI
import CoreNFC


struct ContentView: View {
    @State var dataStock: [String] = []
    
    @State var readingData: String = ""
    
    @ObservedObject var recordVM : RecordViewModel
    
    @State var isPresented: Bool = false
    
    var sessionWrite = NFCSessionWrite()
    
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
        VStack{
            
            
            GeometryReader{ reader in
                
                VStack{
                    
                    Text("ピッとたいむ")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.9137203097, green: 0.5255223513, blue: 0.5842515826, alpha: 1)))
                    List{
                        ForEach(self.recordVM.records, id:\.input){ record in
                            CardView(content: record.input)
                        }.onDelete(perform: delete)
                    }.background(Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)))
                    
                    
                    .sheet(isPresented: $isPresented, onDismiss: {
                        print("onDismiss")
                        self.recordVM.fetchAllRecords()
                        
                    }, content: {
                        VStack{
                            Text("あしあとを書きこみましよう！")
                                .font(.title2)
                                .foregroundColor(Color(#colorLiteral(red: 0.9150015712, green: 0.5250076056, blue: 0.582652986, alpha: 1))).padding()

                            
                            
                            
                            // Write Button
                            Button(action: {
                                self.sessionWrite.beginScanning()
                                isPresented.toggle()
                            }, label: {
                                Text("①あしあとを書きこむ")
                                    .font(.title)
                                    .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.15)
                            })
                            .foregroundColor(.white)
                            .background(Color("black-pinkcolor"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding()
                        }
                    })
                    Button(action: {
                        isPresented.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.title)
                            .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.07)
                    })
                    .foregroundColor(.white)
                    .background(Color("black-pinkcolor"))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            Spacer()
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

