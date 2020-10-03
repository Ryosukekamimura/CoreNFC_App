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
}
