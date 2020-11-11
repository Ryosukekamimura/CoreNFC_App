//
//  CardView.swift
//  UseCoreNFC
//
//  Created by 神村亮佑 on 2020/10/04.
//

import SwiftUI

struct CardView: View {
    
    var content: String
    
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
    
    var body: some View {
        
        HStack{
            Spacer()
            HStack{
                Spacer()
                Image(systemName: "sun.max.fill")
                Spacer()
                Text("\(month(content: content))" + "/" + "\(day(content: content))")
                    .foregroundColor(Color("black-pinkcolor"))
                    .padding()
                Spacer()
                Text("\(hour(content: content)):" + "\(minutes(content: content))")
                    .foregroundColor(Color("black-pinkcolor"))
                    .bold()
                Spacer()
            }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
            
            Spacer()    
            
        }.background(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
        
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020年11月01日 07時52分42秒 +0900").previewLayout(.sizeThatFits)
        
    }
}
