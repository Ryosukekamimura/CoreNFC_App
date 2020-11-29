//
//  CoreDataManager.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(moc: NSManagedObjectContext.current)
    var moc: NSManagedObjectContext
    
    private init(moc: NSManagedObjectContext){
        self.moc = moc
    }
    
    
    private func fetchRecord(input: String) -> Record? {
        var records = [Record]()
        let request: NSFetchRequest<Record> = Record.fetchRequest()
        request.predicate = NSPredicate(format: "input == %@", input)
        
        do{
            records = try self.moc.fetch(request)
        }catch let error as NSError {
            print(error)
        }
        return records.first
    }
    
    // delete method
    func deleteRecord(input: String) {
        do {
            if let record = fetchRecord(input: input){
                self.moc.delete(record)
                try self.moc.save()
            }
        }catch let error as NSError{
            print(error)
        }
    }
    
    //
    func getAllRecords() -> [Record] {
        var records = [Record]()
        let recordRequest: NSFetchRequest<Record> = Record.fetchRequest()
        
        do{
            records = try self.moc.fetch(recordRequest)
        }catch let error as NSError{
            print(error)
        }
        return records
    }
    
    // save method
    func saveRecord(input: String) {
        let record = Record(context: self.moc)
        record.input = input
        
        do{
            try self.moc.save()
        }catch let error as NSError{
            print(error)
        }
    }
}
