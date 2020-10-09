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
                .stroke(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), lineWidth: 10)
                .padding(10)
            
            
            HStack{
                
                Text("\(DateUtils.stringFromDateOnlyMonth(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))\(DateUtils.stringFromDateOnlyDay(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))日")
                    .foregroundColor(.black)
                    .fontWeight(.bold)
                    .padding(30)
        
                Text("\(DateUtils.stringFromDateOnlyHour(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z"))):\(DateUtils.stringFromDateOnlyMinutes(date: DateUtils.dateFromString(string: content, format: "yyyy年MM月dd日 HH時mm分ss秒 Z")))")
                // MARK - Change Font
                    .foregroundColor(Color(#colorLiteral(red: 0.9293251634, green: 0.9490733743, blue: 0.9724329114, alpha: 1)))
                    .padding([.all], 20)
                    .background(Color(#colorLiteral(red: 0.4979934692, green: 0.4980685115, blue: 0.497977078, alpha: 1)))
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
