//
//  NFCButtonView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import UIKit
import CoreNFC
import SwiftUI


// NFC Read


struct nfcButton : UIViewRepresentable {
    
    @Binding var data : String
    @Binding var dataStock : [String]

    
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
        return Coordinator(data: $data, dataStock: $dataStock)
    }
    
    class Coordinator: NSObject, NFCNDEFReaderSessionDelegate{
        
        
        var session : NFCNDEFReaderSession?
        @Binding var data : String
        @Binding var dataStock: [String]
        
        @State var addRecordVM = AddRecordViewModel()
        @ObservedObject var recordVM: RecordViewModel = RecordViewModel()
    
        
        var input_str : String = ""
        
        init(data: Binding<String>, dataStock: Binding<[String]>) {
            _data = data
            _dataStock = dataStock
            
            
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
            //self.data = payload
            
            
            // dataStock をデータ永続化にする
            addRecordVM.input = payload
            
//            self.dataStock.append(self.data)
//            print("dataStock is \(self.dataStock)")
//
            
            addRecordVM.saveRecord()
            
            self.recordVM.fetchAllRecords()
            
        }
        
        
    }
    
}

