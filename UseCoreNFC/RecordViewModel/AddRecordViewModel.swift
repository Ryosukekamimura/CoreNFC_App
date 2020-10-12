//
//  AddRecordViewModel.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation


class AddRecordViewModel {
    
    var input: String = ""
    
    func saveRecord() {
        CoreDataManager.shared.saveRecord(input: self.input)
    }
}
