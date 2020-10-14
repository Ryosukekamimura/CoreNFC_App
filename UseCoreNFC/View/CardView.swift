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
        ZStack{
            Rectangle()
                .stroke(Color("black-pinkcolor"), lineWidth: 10)
                .padding(10)
            HStack{
                Text("\(DateUtils.stringFromDateOnlyMonth(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))\(DateUtils.stringFromDateOnlyDay(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))日")
                    .foregroundColor(Color("black-pinkcolor"))
                    .fontWeight(.bold)
                    .padding(30)
                Text("\(DateUtils.stringFromDateOnlyHour(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))):\(DateUtils.stringFromDateOnlyMinutes(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))")
                // MARK - Change Font
                    .foregroundColor(Color("black-pinkcolor"))
                    .font(.title)
                    .padding([.all], 20)
                    .cornerRadius(20)
            }.padding()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020-10-1")
    }
}
