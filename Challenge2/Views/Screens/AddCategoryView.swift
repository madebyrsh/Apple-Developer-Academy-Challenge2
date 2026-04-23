//
//  AddCategoryView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/23/26.
//

import SwiftUI

struct AddCategoryView: View {
    
    @Binding var selectedCategories: [String]
    @Environment(\.dismiss) private var dismiss
    
    let allCategories: [String] = [
        "기획", "디자인", "독서", "음악", "영화",
        "일본어", "영어", "다이빙", "테니스", "여행",
        "게임", "헬스"
    ]
    
    var availableCategories: [String] { // 아직 추가되지 않은 관심사만 계산 시작
        allCategories.filter { !selectedCategories.contains($0) }
    } // 아직 추가되지 않은 관심사만 계산 종료
    
    var body: some View {
        
        NavigationStack { // NavigationStack 시작
            
            List { // List 시작
                
                if availableCategories.isEmpty { // 추가 가능한 관심사가 없을 때 시작
                    
                    Text("추가할 수 있는 관심사가 없습니다.")
                        .foregroundColor(.gray)
                    
                } else { // 추가 가능한 관심사가 있을 때 시작
                    
                    ForEach(availableCategories, id: \.self) { category in // ForEach 시작
                        Button {
                            selectedCategories.append(category)
                            dismiss()
                        } label: {
                            Text(category)
                                .foregroundColor(.primary)
                        }
                    } // ForEach 종료
                    
                } // 추가 가능한 관심사가 있을 때 종료
                
            } // List 종료
            .navigationTitle("관심사 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // toolbar 시작
                ToolbarItem(placement: .topBarLeading) {
                    Button("닫기") {
                        dismiss()
                    }
                }
            } // toolbar 종료
            
        } // NavigationStack 종료
    }
}



#Preview { // Preview 시작
    AddCategoryView(selectedCategories: .constant(["일본어", "디자인"]))
} // Preview 종료
