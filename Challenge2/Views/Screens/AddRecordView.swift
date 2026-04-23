//
//  AddRecordView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/22/26.
//

import SwiftUI
import SwiftData
import CoreLocation
import MapKit
import Combine

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    private let manager = CLLocationManager()
    
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestCurrentLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 실패: \(error.localizedDescription)")
    }
}

struct AddRecordView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var locationManager = LocationManager() // 위치 매니저를 상태 객체로 보관
    
    @State private var name: String = ""
    @State private var selectedSession: String =  "오전"
    @State private var selectedCategory: String = "디자인"
    
    @State private var activity: String = ""
    @State private var placeName: String = ""

    @State private var latitude: Double = 0.0
    @State private var longitude: Double = 0.0
    
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
                
                Section("만남 정보") {
                    
                    TextField("어디서 만났나요?", text: $placeName)
                    
                    TextField("어떤 활동을 했나요?", text: $activity, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("위치 저장") {
                    
                    Button("현재 위치 저장") {
                        locationManager.requestCurrentLocation()
                    }
                    
                    if latitude != 0.0 && longitude != 0.0 {
                        
                        
                        Map(
                            initialPosition: .region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                                )
                            )
                        ) {
                            Marker(
                                "만난 위치",
                                coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                            )
                        }
                        .frame(height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
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
            .onReceive(locationManager.$latitude) { value in
                latitude = value
            }
            .onReceive(locationManager.$longitude) { value in
                longitude = value
            }
        }
        
    }
    
    private func saveRecord() {
        let newRecord = MeetingRecord(
            name: name,
            session: selectedSession,
            category: selectedCategory
        )
        
        newRecord.activity = activity
        newRecord.placeName = placeName
        newRecord.latitude = latitude
        newRecord.longitude = longitude
        
        modelContext.insert(newRecord)
        dismiss()
    }
}

#Preview {
    AddRecordView(categories: ["디자인","일본어", "영어", "영화", "음악", "운동", "테니스"])
        .modelContainer(for: MeetingRecord.self, inMemory: true)
}
