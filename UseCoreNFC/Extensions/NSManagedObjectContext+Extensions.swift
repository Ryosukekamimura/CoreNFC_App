//
//  NSManagedObjectContext+Extensions.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/08.
//

import Foundation
import UIKit
import CoreData


extension NSManagedObjectContext {
    static var current: NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
}
