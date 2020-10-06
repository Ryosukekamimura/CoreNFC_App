//
//  DateFormatter.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/02.
//

import Foundation
import UIKit

class DateUtils {
    class func stringFromDate(date: Date, format: String) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    class func stringFromDateOnlyMonth(date: Date) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: date)
    }
    
    class func stringFromDateOnlyDay(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
    
    class func stringFromDateOnlyHour(date: Date) -> String{
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "H", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
    
    class func stringFromDateOnlyMinutes(date: Date) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "m", options: 0, locale: Locale(identifier: "jp_JP"))
        return formatter.string(from: date)
    }
}
