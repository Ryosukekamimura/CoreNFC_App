//
//  RecordModel.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation


struct RecordModel {
    var input: String
    
    //CoreData Model --> Record
    init(record: Record) {
        self.input = record.input!
    }
}
