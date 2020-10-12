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
    @Binding var isPresented: Bool

    func makeUIView(context: UIViewRepresentableContext<nfcButton>) -> UIButton {
        let button = UIButton()
        button.setTitle("②あしあとを読みこむ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        button.backgroundColor = UIColor.black
        button.addTarget(context.coordinator, action: #selector(context.coordinator.beginScan(_:)), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: UIViewRepresentableContext<nfcButton>) {
        // do nothing
    }
    
    typealias UIViewType = UIButton
    
    func makeCoordinator() -> nfcButton.Coordinator {
        return Coordinator(isPresented: $isPresented)
    }
    
    class Coordinator: NSObject, NFCNDEFReaderSessionDelegate{
        var session : NFCNDEFReaderSession?
        
        @Binding var isPresented: Bool
        
        @State var addRecordVM = AddRecordViewModel()
        @ObservedObject var recordVM: RecordViewModel = RecordViewModel()
    
        
        
        init(isPresented: Binding<Bool>) {
            _isPresented = isPresented
        }
        
        
        
        @objc func beginScan(_ sender: Any){
            guard NFCNDEFReaderSession.readingAvailable else {
                print("申し訳ございません、対応していない機種です")
                return
            }
            
            session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
            session?.alertMessage = "デバイスを近づけてください"
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
            print("次の内容を読み取れました - \(payload)")
            // Write to CoreData
            addRecordVM.input = payload
            // Save to CoreData
            addRecordVM.saveRecord()
            // Display Sheet
            isPresented.toggle()
        }
        
        
    }
    
}

