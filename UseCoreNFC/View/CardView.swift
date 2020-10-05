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
        HStack{
            
            Text("\(content)")
                .foregroundColor(.black)
                .fontWeight(.bold)
    
            Text("04:50")
            // MARK - Change Font
                .foregroundColor(Color(#colorLiteral(red: 0.9293251634, green: 0.9490733743, blue: 0.9724329114, alpha: 1)))
                .padding([.all], 20)
                .background(Color(#colorLiteral(red: 0.5881891251, green: 0.5608165264, blue: 0.5450313687, alpha: 1)))
                .cornerRadius(20)
            

        }.padding()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(content: "2020-10-1")
    }
}
