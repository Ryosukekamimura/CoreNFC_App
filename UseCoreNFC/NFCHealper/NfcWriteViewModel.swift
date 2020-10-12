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
    


    
    public func  beginScanning(){
        guard NFCNDEFReaderSession.readingAvailable else{
            print("スキャンに対応されていない機種です。申し訳ございません。")
            return
        }
        session = NFCNDEFReaderSession(delegate: self, queue: .main, invalidateAfterFirstRead: false)
        session?.alertMessage = "データを書き込むのでNFCタグに近づけてください"
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
                session.alertMessage = "NFCタグに書き込むことが出来ませんでした。もう一度お試しください"
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
                    
                    // MARK: - Date を読み取り書き込む
                    let nowTime = Date()
                    print("現在の時刻を取得する\(nowTime)")
                    print(type(of: nowTime))
                    
                    let format_nowTime = DateUtils.stringFromDate(date: nowTime, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")
                    
                    print("\(format_nowTime)フォーマットされた現在時刻を表示")
                    //self.readingData = format_nowTime

                    payLoad = NFCNDEFPayload(
                        format: .nfcWellKnown,
                        type: "T".data(using: .utf8)!,
                        identifier: "Text".data(using: .utf8)!,
                        payload: format_nowTime.data(using: .utf8)!
                    )
                    
                    print("\(format_nowTime)　フォーマットされた現在時刻を表示する")
                    
                    //make our message array
                    let nfcMessage = NFCNDEFMessage(records: [payLoad!])
                    print("\(nfcMessage)")
                    
                    // write to tag
                    tag.writeNDEF(nfcMessage) { (error) in
                        if error != nil {
                            session.alertMessage = "Write NDEF fail : \(error!.localizedDescription)"
                            print("fail write : \(String(describing: error?.localizedDescription))")
                        } else {
                            
                            // to write
                            session.alertMessage = "書き込むことに成功しました！"
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
