//
//  RecordModel.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation


class RecordModel {
    var input: String
    
    init(record: Record) {
        self.input = record.input!
    }
}
