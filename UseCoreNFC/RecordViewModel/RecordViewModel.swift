//
//  RecordViewModel.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation
import CoreData



class RecordViewModel: ObservableObject {
    @Published var records = [RecordModel]()
    
    init() {
        fetchAllRecords()
    }
    
    func deleteRecord(_ recordVM: RecordModel){
        CoreDataManager.shared.deleteRecord(input: recordVM.input)
        fetchAllRecords()
    }
    
    func fetchAllRecords() {
        self.records = CoreDataManager.shared.getAllRecords().map(RecordModel.init)
        print("\(self.records)recordsはこれです")
    }
    
    
}
