//
//  EditRecordView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/22/26.
//

import SwiftUI
import SwiftData

struct EditRecordView: View {
    
    @Bindable var record: MeetingRecord
    @Environment(\.dismiss) private var dismiss
    
    let categories: [String]
    let session = ["오전","오후"]
    
    var body: some View {
        Form {
            Section("기본 정보") {
                TextField("이름 또는 닉네임", text: $record.name)
                
                Picker("세션", selection: $record.session) {
                    ForEach(session, id: \.self) {session in
                        Text(session)
                    }
                }
                Picker("카테고리", selection: $record.category) {
                    ForEach(categories, id: \.self) {category in
                        Text(category)
                    }
                }
            }
        }
        .navigationTitle("기록 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("완료") {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    EditRecordView(
        record: MeetingRecord(name: "사라", session: "오후", category: "일본어"),
        categories: ["일본어","디자인","영화"]
    )
}
