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
    let holder = "Read message will display here ..."
    
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
                    NavigationLink(destination: WriteView(isActive: self.$showWrite), isActive: self.$showWrite){
                        Button(action: {
                            self.showWrite.toggle()
                        }, label: {
                            Text("Write NFC ")
                                .frame(width: reader.size.width * 0.9, height: reader.size.height * 0.07)
                        }).foregroundColor(.white)
                        .background(Color(.black))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        
                    }
                    
                    
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

struct Payload {
    var type : RecordType
    var pickerMsg : String
}


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

// NFC Write
enum RecordType {
    case text, url
}


class NFCSessionWrite : NSObject, NFCNDEFReaderSessionDelegate{
    var session : NFCNDEFReaderSession?
    var message : String = ""
    var recordType : RecordType = .text
    
    
    
    func  beginScanning(message: String, recordType: RecordType){
        guard NFCNDEFReaderSession.readingAvailable else{
            print("Scanning not support for this device.")
            return
            
        }
        self.message = message
        self.recordType = recordType
        
        session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone newar an NFC tag to write message."
        session?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Do nothing here unless you want to impletent error
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        // Do nothing here
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // This is to silence console.
    }
    
    // Write function
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            //restart session for 2 seconds
            let retryInterval = DispatchTimeInterval.milliseconds(2000)
            session.alertMessage = "More than 1 tag is detected. Remoe all tag and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            
            return
        }
        // Connect to the tag once we know only 1 tag is found
        let tag = tags.first!
        print("Get First tag!")
        session.connect(to: tag){ (error) in
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                print("Error connect")
                return
                
            }
            
            
            // Query tag if no error occur
            tag.queryNDEFStatus {(ndefStatus, capacity, error) in
                if error != nil {
                    session.alertMessage = "Unable to query the NFC NDEF tag."
                    session.invalidate()
                    print("Error query tag.")
                    return
                }
                
                //proceed to query
                switch ndefStatus {
                
                
                case .notSupported:
                    print("Not Supoort")
                    session.alertMessage = "Tag is not NDEF complaint"
                    session.invalidate()
                case .readWrite:
                    // Writing code logic
                    print("Read Write")
                    let payLoad : NFCNDEFPayload?
                    switch self.recordType {
                    
                    case .text:
                        guard !self.message.isEmpty else {
                            session.alertMessage = "Empty Data"
                            session.invalidate(errorMessage: "Empty Text data")
                            return
                        }
                        
                        payLoad = NFCNDEFPayload(
                            format: .nfcWellKnown,
                            type: "T".data(using: .utf8)!,
                            identifier: "Text".data(using: .utf8)!,
                            payload: self.message.data(using: .utf8)!
                        )
                    
                    case .url :
                        //Make sure our URL is actual URL
                        guard let url = URL(string: self.message) else {
                            print("Not a valid URL")
                            session.alertMessage = "Unrecognize URL"
                            session.invalidate(errorMessage: "Data is not a URL")
                            return
                        }
                        
                        // make paypload
                        payLoad = NFCNDEFPayload.wellKnownTypeURIPayload(url: url)
                        
                    }
                    
                    //make our message array
                    let nfcMessage = NFCNDEFMessage(records: [payLoad!])
                    
                    // write to tag
                    tag.writeNDEF(nfcMessage) { (error) in
                        if error != nil {
                            session.alertMessage = "Write NDEF fail : \(error!.localizedDescription)"
                            print("fail write : \(String(describing: error?.localizedDescription))")
                        } else {
                            session.alertMessage = "Write NDEF successful."
                            print("Success write.")
                        }
                        
                        session.invalidate()
                    }
                    
                    
                case .readOnly:
                    print("Read Only")
                    session.alertMessage = "Tag is read only."
                    session.invalidate()
                
                @unknown default:
                    print("Unkwon error")
                    session.alertMessage = "Unknown NDEF tag status"
                    session.invalidate()
                     
                }
            }
            
        }
    }
    
    
    
}


// NFC Read

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
