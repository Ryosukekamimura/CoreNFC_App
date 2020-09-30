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
    
    var body: some View {
        NavigationView{
            GeometryReader{ reader in
                VStack(spacing: 30){
                    ZStack{
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 4))
                        
                        Text(data)
                            .foregroundColor(.black)
                            .padding()
                    }.frame(height: reader.size.height * 0.4)
                    nfcButton(data: self.$data)
                        .frame(height: reader.size.height * 0.07)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    // Write Button
                    
                    Spacer()
                }.frame(width: reader.size.width * 0.9)
                .navigationBarTitle("NFC App", displayMode: .inline)
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


struct nfcButton : UIViewRepresentable {
    
    @Binding var data : String
    
    func makeUIView(context: UIViewRepresentableContext<nfcButton>) -> UIButton {
        let button = UIButton()
        button.setTitle("ReadNFC", for: .normal)
        button.backgroundColor = UIColor.black
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
        return button
        
        
        
    }
    
    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<nfcButton>) {
        // do nothing
    }
    
    typealias UIViewType = UIButton
    
    func makeCoordinator() -> nfcButton.Coordinator {
        return Coordinator(data: $data)
    }
    
    class Coordinator: NSObject, NFCNDEFReaderSessionDelegate{
        
        
        var session : NFCNDEFReaderSession?
        @Binding var data : String
        
        init(data: Binding<String>) {
            _data = data
        }
        
        
        
        @objc func beginScan(_ sender: Any){
            guard NFCNDEFReaderSession.readingAvailable else {
                print("error: Scanning not support")
                return
            }
            
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
            session?.alertMessage = "Hold your iphone near to scan."
            session?.begin()
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
            
            // Check the invalidation reason from the returned error.
            if let readerError = error as? NFCReaderError{
                if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead) && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                    print("Error nfc read : \(readerError.localizedDescription)")
                }
            }
            
            // To read new tags, a new session instance is required.
            
            self.session = nil
        }
        
        func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
            guard let nfcMess = messages.first,
                  let record = nfcMess.records.first,
                  record.typeNameFormat == .absoluteURI || record.typeNameFormat == .nfcWellKnown,
                  let payload = String(data: record.payload, encoding: .utf8)
            else {
                return
            }
            
            
            print(payload)
            self.data = payload
        }
        
        
    }
    
}
