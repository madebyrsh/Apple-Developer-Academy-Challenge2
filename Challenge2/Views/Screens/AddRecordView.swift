//
//  AddRecordView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/22/26.
//

import SwiftUI
import SwiftData

struct AddRecordView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var selectedSession: String =  "오전"
    @State private var selectedCategory: String = "디자인"
    
    let categories: [String]
    let sessions = ["오전", "오후"]
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section("기본 정보") {
                    TextField("이름 또는 닉네임", text: $name)
                    
                    Picker("세션", selection:  $selectedSession) {
                        ForEach(sessions, id: \.self) { session  in
                            Text(session)
                        }
                    }
                    
                    Picker("카테고리", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    
                }
            } //Form 종료
            .navigationTitle("기록 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("취소") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("저장") {
                        saveRecord()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        
    }
    
    private func saveRecord() {
        let newRecord = MeetingRecord(
            name: name,
            session: selectedSession,
            category: selectedCategory
        )
        
        modelContext.insert(newRecord)
        dismiss()
    }
}

#Preview {
    AddRecordView(categories: ["디자인","일본어", "영어", "영화", "음악", "운동", "테니스"])
        .modelContainer(for: MeetingRecord.self, inMemory: true)
}
