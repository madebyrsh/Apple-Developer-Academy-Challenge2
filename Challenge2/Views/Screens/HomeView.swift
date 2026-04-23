//
//  HomeView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/21/26.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Binding var selectedCategories: [String]
    @State private var isShowingAddRecordView = false
    @State private var isShowingAddCategoryView = false
    @State private var isEditingCategories = false
    @State private var selectedCategoriesToDelete: Set<String> = []
    
    @Query(sort: \MeetingRecord.createdAt, order: .reverse)
    private var records: [MeetingRecord]
    
    //하단 고정 버튼 영역 높이
    private let bottomButtonAreaHeight: CGFloat = 110
    
    var body: some View {
        NavigationStack { // NavigationStack 시작
            
            ZStack { // ZStack 시작
                AppBackgroundView()
                
                // 1. 제목 + 카테고리 박스만 스크롤되는 영역
                ScrollView(showsIndicators: false) { // ScrollView 시작
                    VStack(alignment: .leading, spacing: 24) { // 스크롤 콘텐츠 VStack 시작
                        
                        HStack { // 헤더 HStack 시작
                            Text("만남 기록")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            if isEditingCategories { // 편집 모드일 때 시작
                                
                                Button("취소") {
                                    isEditingCategories = false
                                    selectedCategoriesToDelete.removeAll()
                                }
                                .foregroundColor(.primary)
                                
                                Button("삭제") {
                                    deleteSelectedCategories()
                                }
                                .foregroundColor(.red)
                                .disabled(selectedCategoriesToDelete.isEmpty)
                                
                            } else { // 평소 모드일 때 시작
                                
                                HStack(spacing: 14) { // 아이콘 버튼 묶음 시작
                                    
                                    Button {
                                        isEditingCategories = true
                                    } label: {
                                        Image(systemName: "pencil.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.primary)
                                    }
                                    
                                    Button {
                                        isShowingAddCategoryView = true
                                    } label: {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.largeTitle)
                                            .foregroundColor(.primary)
                                    }
                                    
                                } // 아이콘 버튼 묶음 종료
                                
                            } // 평소 모드일 때 종료
                        } // 헤더 HStack 종료
                        
                        // 카테고리 섹션들 (스크롤됨)
                        ForEach(selectedCategories, id: \.self) { category in // ForEach 시작
                            CategorySectionView(
                                category: category,
                                categories: selectedCategories,
                                records: recordsForCategory(category),
                                isEditing: isEditingCategories,
                                isSelected: selectedCategoriesToDelete.contains(category),
                                onTapInEditingMode: {
                                    toggleCategorySelection(category)
                                }
                            )
                        } // ForEach 종료
                        
                    } // 스크롤 콘텐츠 VStack 종료
                    .padding(.horizontal, 24)
                    .padding(.top, 80)
                    .padding(.bottom, bottomButtonAreaHeight)
                } // ScrollView 종료
                
                
                // 2. 하단 고정 버튼 영역
                VStack { // 하단 고정용 VStack 시작
                    Spacer()
                    
                    Button {
                        isShowingAddRecordView = true
                    } label: {
                        Text("기록 추가하기")
                            .font(Font.custom("Apple SD Gothic Neo", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 48)
                    
                } // 하단 고정용 VStack 종료
                
            } // ZStack 종료
            .sheet(isPresented: $isShowingAddRecordView) { // sheet 시작
                AddRecordView(categories: selectedCategories)
            } // sheet 종료
            .sheet(isPresented: $isShowingAddCategoryView) {
                AddCategoryView(selectedCategories: $selectedCategories)
            }
            
        } // NavigationStack 종료
    }
    
    private func recordsForCategory(_ category: String) -> [MeetingRecord] {
        records.filter { $0.category == category }
    }
    
    private func toggleCategorySelection(_ category: String) { // 선택/해제 함수 시작
        if selectedCategoriesToDelete.contains(category) {
            selectedCategoriesToDelete.remove(category)
        } else {
            selectedCategoriesToDelete.insert(category)
        }
    } // 선택/해제 함수 종료
    private func deleteSelectedCategories() { // 삭제 함수 시작
        selectedCategories.removeAll { selectedCategoriesToDelete.contains($0) }
        selectedCategoriesToDelete.removeAll()
        isEditingCategories = false
    } // 삭제 함수 종료
    
}



#Preview {
    HomeView(selectedCategories: .constant(["일본어", "디자인", "영화"]))
        .modelContainer(for: MeetingRecord.self, inMemory: true)
}
