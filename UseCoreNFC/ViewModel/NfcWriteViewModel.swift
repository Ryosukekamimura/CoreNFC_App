//
//  NfcWrite.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import SwiftUI
import CoreNFC
import UIKit


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
                        
                        // Date を読み取り書き込む
                        
                        
                        

                        payLoad = NFCNDEFPayload(
                            format: .nfcWellKnown,
                            type: "T".data(using: .utf8)!,
                            identifier: "Text".data(using: .utf8)!,
                            payload: self.message.data(using: .utf8)! + "2020-10-2 13:30".data(using: .utf8)!
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
