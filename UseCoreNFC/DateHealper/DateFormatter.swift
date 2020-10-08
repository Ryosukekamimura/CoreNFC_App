//
//  DateFormatter.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import Foundation
import UIKit

class DateUtils {
    // Date型からString
    class func stringFromDate(date: Date, format: String) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    // String型からDate
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    // String型のMonth　--> "09"
    class func stringFromDateOnlyMonth(date: Date) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: date)
    }
    
    // String型のDay --> "2"
    class func stringFromDateOnlyDay(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
    
    // String型のHour　--> "3"
    class func stringFromDateOnlyHour(date: Date) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "H", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
    
    // String型のMinutes --> "03"
    class func stringFromDateOnlyMinutes(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "mm", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
}
