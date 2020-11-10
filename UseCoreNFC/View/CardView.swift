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
        
        HStack{
            Spacer()
            HStack{
                Spacer()
                Text("\(month(content: content))" + "/" + "\(day(content: content))")
                    .foregroundColor(Color("black-pinkcolor"))
                    .padding()
                Spacer()
                Text("\(hour(content: content)):" + "\(minutes(content: content))")
                    .foregroundColor(Color("black-pinkcolor"))
                    .bold()
                Spacer()
            }.background(Color(#colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)))
            
            Spacer()
            
        }.padding()
        
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020年11月01日 07時52分42秒 +0900").previewLayout(.sizeThatFits)
        
    }
}
