//
//  InterestSelectionView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/20/26.
//

import SwiftUI

struct InterestSelectionView: View {
    
    @Binding var selectedCategories: [String]
    @Binding var hasCompletedSelection: Bool
    
    let interestsRows: [[(emoji: String, title: String)]] = [
        
        [("📊", "기획"),("🎨", "디자인")],
        [("📚", "독서"),("🎵", "음악"),("🍿", "영화")],
        [("🇯🇵", "일본어"),("🇬🇧", "영어")],
        [("🤿", "다이빙"),("🎾", "테니스"),("✈️", "여행")],
        [("🎮", "게임"),("🏋🏻", "헬스")]
    ]
    
    @State private var selectedInterests: Set<String> = []
    
    
    
    var body: some View {
        
        // ZStack 시작점
        ZStack {
            AppBackgroundView()
            
            //VStack 시작점
            VStack(alignment: .leading, spacing: 16) {
                Text("관심사를\n선택하세요")
                //Text Modifier
                    .font(Font.custom("Apple SD Gothic Neo", size: 48))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .kerning(-0.5)//자간
                    .lineSpacing(4)//행간
                
                Text("생각보다 아주 가까운 곳에\n같은 관심을 가진 사람이 있을지도 몰라요")
                    .font(Font.custom("Apple SD Gothic Neo", size: 18))
                    .fontWeight(.regular)
                    .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                    .kerning(-0.5)//자간
                    .lineSpacing(4)//행간
                
                
                VStack (spacing: 16) {
                    ForEach(interestsRows.indices, id: \.self) { rowIndex in
                        
                        HStack (spacing: 12){
                            ForEach(interestsRows[rowIndex], id: \.title) { interest in
                                InterestChipView (
                                    emoji: interest.emoji,
                                    title: interest.title,
                                    isSelected: selectedInterests.contains(interest.title)
                                ) {
                                    if selectedInterests.contains(interest.title) {
                                        selectedInterests.remove(interest.title)
                                    } else {
                                        selectedInterests.insert(interest.title)
                                    }
                                }
                                
                            }
                        } //Hstack 가로영역 종료점
                        
                    }
                } // VStack(칩영역) 종료점
                .padding(.top, 24) // VStack과 VStack 간의 간격
                
                Spacer()
                
                VStack (spacing: 12){
                    Text("관심사를 선택하고 시작해보세요")
                        .font(Font.custom("Apple SD Gothic Neo", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(Color(red: 0.6, green: 0.6, blue: 0.6))
                        .frame(maxWidth: .infinity)
                        
                    Button(action:{
                        selectedCategories = Array(selectedInterests)
                        hasCompletedSelection = true
                    }) {
                        Text("선택 완료")
                            .font(Font.custom("Apple SD Gothic Neo", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 1, green: 0.99, blue: 0.96))
                            .frame(maxWidth: .infinity,)
                            .frame(height: 56)
                            .background(
                                selectedInterests.isEmpty
                                ? Color(red: 0.8, green: 0.8, blue: 0.8)
                                : Color(red: 0.12, green: 0.12, blue: 0.12))
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .disabled(selectedInterests.isEmpty)
                }
                .padding(.bottom,48)
               
                
                
                
                
            } // VStack 종료점
            .padding(.horizontal, 24)
            .padding(.top, 70)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) //전체화면을 레이아웃으로 쓰게 하고 좌측 정렬
            
            
        } // ZStack 종료점
        
       
    }
}

#Preview {
    InterestSelectionView(
        selectedCategories: .constant([]),
        hasCompletedSelection: .constant(false)
    )
}
