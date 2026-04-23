//
//  InterestChipView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/20/26.
//

import SwiftUI

struct InterestChipView: View {
    let emoji: String // 버튼 emoji
    let title: String// 버튼 관심사명
    let isSelected: Bool // 선택되었는지 아닌지 판단
    let action: () -> Void // 눌렀을때 할일
    
    var body: some View {
        Button(action: action){
            HStack ( spacing: 6){
                Text(emoji)
                Text(title)
                    .font(.custom("Apple SD Gothic Neo", size: 16))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .foregroundColor(
                        isSelected
                        ? Color(red: 1, green: 0.99, blue: 0.96)
                        : Color(red: 0.13, green: 0.13, blue: 0.13)
                    )
                
            }// HStack 종료점
            .frame(width: 110 )
            .frame(height: 50)
            .contentShape(Capsule())
           
        }//Button 종료점
        .buttonStyle(.plain)
        .glassEffect(
            isSelected
            ? .regular.tint(Color(red: 0.23, green: 0.57, blue: 0.81, opacity: 0.5))
            : .clear,//.tint(Color(red: 1, green: 0.99, blue: 0.96, opacity: 0.2)),
            in: Capsule()
        )
    }//View 종료점
}

#Preview {
    InterestChipView(
        emoji: "📊",
        title: "일본어",
        isSelected: false,
        action: {}
        
    )
   
    
}
