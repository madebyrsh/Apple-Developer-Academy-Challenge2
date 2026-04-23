//
//  CategoryListView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/22/26.
//

import SwiftUI
import SwiftData

struct CategoryListView: View {
    
    let category: String
    let categories: [String]
    
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort: \MeetingRecord.createdAt, order: .reverse)
    private var records: [MeetingRecord]
    
    var filteredRecords: [MeetingRecord] {
        records.filter { $0.category == category }
    }
    
    var body: some View {
        
        Group {
            if filteredRecords.isEmpty {
                VStack(spacing: 12) {
                    Text("아직 기록이 없습니다")
                        .font(.headline)
                    
                    Text("\(category) 카테고리에 추가된 만남 기록이 없습니다")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            } else {
                List {
                    ForEach(filteredRecords) { record in
                        NavigationLink {
                            EditRecordView(
                                record: record,
                                categories: categories
                            )
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(record.name)
                                    .font(.headline)
                                
                                Text("\(record.session) 세션")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteRecords)
                }
                
            }
        }
        .navigationTitle(category)
    }
    
    private func deleteRecords(at offsets: IndexSet) {
        for index in offsets {
            let record = filteredRecords[index]
            modelContext.delete(record)
        }
    }
    
}

#Preview {
    CategoryListView(
        category: "일본어",
        categories:  ["일본어", "디자인", "영화"]
    
    )
        .modelContainer(for: MeetingRecord.self, inMemory: true)
    
}
