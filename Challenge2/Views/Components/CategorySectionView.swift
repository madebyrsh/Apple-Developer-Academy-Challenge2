//
//  CategorySectionView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/21/26.
//

import SwiftUI

struct CategorySectionView: View {
    
    let category: String
    let categories: [String]
    let records: [MeetingRecord]
    let isEditing: Bool
    let isSelected: Bool
    let onTapInEditingMode: () -> Void
    
    var body: some View {
        
        Group { // Group 시작
            
            if isEditing { // 편집 모드일 때 시작
                
                Button {
                    onTapInEditingMode()
                } label: {
                    cardContent
                }
                .buttonStyle(.plain)
                
            } else { // 평소 모드일 때 시작
                
                NavigationLink {
                    CategoryListView(
                        category: category,
                        categories: categories
                    )
                } label: {
                    cardContent
                }
                .buttonStyle(.plain)
                
            } // 평소 모드일 때 종료
            
        } // Group 종료
        
    } // body 종료
    
    
    private var cardContent: some View { // 카드 UI 시작
        
        VStack(alignment: .leading, spacing: 8) { // 카드 전체 VStack 시작
            
            HStack { // 카드 헤더 시작
                
                Text(category)
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                if isEditing { // 편집 모드 표시 시작
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                        .foregroundColor(isSelected ? .blue : .gray)
                } // 편집 모드 표시 종료
                
            } // 카드 헤더 종료
            
            Divider()
            
            if records.isEmpty { // 기록 없을 때 시작
                
                Text("아직 기록이 없습니다.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            } else { // 기록 있을 때 시작
                
                ForEach(Array(records.prefix(3)), id: \.id) { record in // 최대 3개 미리보기 시작
                    Text("\(record.name) • \(record.session) 세션")
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } // 최대 3개 미리보기 종료
                
            } // 기록 있을 때 종료
            
        } // 카드 전체 VStack 종료
        .padding(24)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 24))
        .overlay { // 선택 테두리 시작
            RoundedRectangle(cornerRadius: 24)
                .stroke(isEditing && isSelected ? Color.blue : Color.clear, lineWidth: 2)
        } // 선택 테두리 종료
        
    } // 카드 UI 종료
    
} // CategorySectionView 종료


#Preview { // Preview 시작
    CategorySectionView(
        category: "일본어",
        categories: ["일본어", "디자인", "영화"],
        records: [],
        isEditing: false,
        isSelected: false,
        onTapInEditingMode: {}
    )
} // Preview 종료
