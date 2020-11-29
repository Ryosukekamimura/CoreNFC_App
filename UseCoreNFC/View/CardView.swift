//
//  CardView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/04.
//

import SwiftUI

struct CardView: View {
    
    var content: String
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 20, content: {
            HStack{
                Spacer()
                Text("\(month(content: content))" + "/" + "\(day(content: content))")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                Spacer()
                Text("\(hour(content: content)):" + "\(minutes(content: content))")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                Spacer()
            }.background(Color(.white))
        })
        .cornerRadius(20)
        .background(Color(.white))
    }
    
    //MARK: FUNCTIONS
    func month(content: String) -> String {
        return DateUtils.stringFromDateOnlyMonth(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))
    }
    
    func day(content: String) -> String {
        return DateUtils.stringFromDateOnlyDay(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))
    }
    
    func hour(content: String) -> String{
        return DateUtils.stringFromDateOnlyHour(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))
    }
    
    func minutes(content: String) -> String{
        return DateUtils.stringFromDateOnlyMinutes(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))
    }
    
    func intHour(content: String) -> Int{
        print("intHour = \(DateUtils.HourFromTotalMunutes(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日HH時mm分ss秒 Z")))")
        return DateUtils.HourFromTotalMunutes(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日HH時mm分ss秒 Z"))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020年11月01日 07時52分42秒 +0900").previewLayout(.sizeThatFits)
    }
}
