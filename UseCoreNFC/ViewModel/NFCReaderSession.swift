//
//  NFCReaderSession.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/06.
//

import Foundation
import CoreNFC
import SwiftUI


class NFCReaderSession: NSObject, NFCNDEFReaderSessionDelegate{
    
    var session : NFCNDEFReaderSession?
    @Binding var data : String
    @Binding var dataStock: [String]
    
    init(data: Binding<String>, dataStock: Binding<[String]>) {
        _data = data
        _dataStock = dataStock
    }
    
    @objc func beginScan(){
        guard NFCNDEFReaderSession.readingAvailable else {
            print("スキャンに対応されていない機種です。申し訳ございません。")
            return
        }
        session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: true)
        session?.alertMessage = "NFCタグを読み取るので近づけてください"
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
        print("didINvalidationWithError readerSession is called")
    }
    
    // If it succeeds in reading, this function will be called
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
        self.dataStock.append(self.data)
        print("dataStock is \(self.dataStock)")
        
        print("didDetectNDEFs messagesw is called")
    }
    
    // scanning for new tags.
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        // Nothing to write
    }
}
