//
//  ContentView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/09/30.
//

import SwiftUI
import CoreNFC


struct ContentView: View {
    @ObservedObject var recordVM : RecordViewModel = RecordViewModel()
    
    var sessionWrite = NFCSessionWrite()
    @State var isSheetPresented: Bool = false
    
    var body: some View {
        ZStack{
            VStack{
                GeometryReader{ reader in
                    VStack{
                        Text("ピッとたいむ")
                            .font(.title)
                            .fontWeight(.bold)
                        List{
                            ForEach(self.recordVM.records, id:\.input){ record in
                                CardView(content: record.input)
                                    .background(Color(.white))
                                    .shadow(radius: 10)
                                    .padding()
                            }
                            .onDelete(perform: { indexSet in
                                delete(at: indexSet)
                            })
                            .listRowBackground(Color.white)
                            .background(Color.white)
                        }
                        
                        HStack{
                            Button(action: {
                                self.isSheetPresented.toggle()
                            }, label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.07)
                                    .background(Color(.orange))
                            })
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                    }
                    .sheet(isPresented: $isSheetPresented, onDismiss: {
                        print("onDismiss")
                        self.recordVM.fetchAllRecords()
                    }, content: {
                        WriteView(reader: reader, sessionWrite: sessionWrite, isSheetPresented: $isSheetPresented)
                    })
                }
                Spacer()
            }.background(Color.white)
        }
    }
    //MARK: PRIVATE FUNCTIONS
    private func delete(at offsets: IndexSet){
        offsets.forEach{index in
            let recordVM = self.recordVM.records[index]
            self.recordVM.deleteRecord(recordVM)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

