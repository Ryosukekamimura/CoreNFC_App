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

    var body: some View {
        ZStack{
            Rectangle()
                .stroke(Color("black-pinkcolor"), lineWidth: 10)
                .padding(10)
            HStack{
                Text("\(month(content: content))")
                    .foregroundColor(Color("black-pinkcolor"))
                    .fontWeight(.bold)
                    .padding(30)
                Text("\(day(content: content))日")
                
                
                Text("\(hour(content: content))時")
                    .foregroundColor(Color("black-pinkcolor"))
                    .font(.title)
                    .padding([.all], 20)
                    .cornerRadius(20)
                Text("\(minutes(content: content))分")
            }.padding()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020-10-1")
    }
}
