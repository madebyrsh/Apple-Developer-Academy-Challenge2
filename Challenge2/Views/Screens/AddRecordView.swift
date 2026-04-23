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

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate { // LocationManager 시작
    
    private let manager = CLLocationManager() // 위치 매니저 생성
    
    @Published var latitude: Double = 0.0 // 받아온 위도 저장
    @Published var longitude: Double = 0.0 // 받아온 경도 저장
    
    override init() { // init 시작
        super.init() // NSObject 초기화
        manager.delegate = self // delegate 연결
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters // 너무 높은 정확도 대신 기록용으로 충분한 수준
    } // init 종료
    
    func requestAuthorizationIfNeeded() { // 권한 요청 전용 함수 시작
        let status = manager.authorizationStatus // 현재 권한 상태 확인
        
        if status == .notDetermined { // 아직 권한을 묻지 않은 상태일 때
            manager.requestWhenInUseAuthorization() // 권한 요청
        }
    } // 권한 요청 전용 함수 종료
    
    func requestCurrentLocation() { // 현재 위치 요청 함수 시작
        
        let status = manager.authorizationStatus // 현재 권한 상태 확인
        
        switch status {
        case .notDetermined: // 아직 권한을 물어보지 않은 상태
            manager.requestWhenInUseAuthorization() // 권한만 먼저 요청
            
        case .authorizedWhenInUse, .authorizedAlways: // 이미 허용된 상태
            
            if let currentLocation = manager.location { // 이미 캐시된 최근 위치가 있으면
                latitude = currentLocation.coordinate.latitude // 바로 위도 반영
                longitude = currentLocation.coordinate.longitude // 바로 경도 반영
            } else {
                manager.requestLocation() // 캐시가 없으면 새 위치 1회 요청
            }
            
        case .denied, .restricted: // 권한 거부 또는 제한 상태
            print("위치 권한이 거부되었거나 제한되어 있습니다.")
            
        @unknown default:
            break
        }
        
    } // 현재 위치 요청 함수 종료
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) { // 권한 변경 감지 시작
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways { // 권한이 허용되면
            manager.requestLocation() // 즉시 현재 위치 요청
        }
    } // 권한 변경 감지 종료
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { // 위치 성공 콜백 시작
        guard let location = locations.first else { return } // 첫 번째 위치만 사용
        latitude = location.coordinate.latitude // 위도 저장
        longitude = location.coordinate.longitude // 경도 저장
    } // 위치 성공 콜백 종료
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) { // 위치 실패 콜백 시작
        print("위치 실패: \(error.localizedDescription)") // 에러 출력
    } // 위치 실패 콜백 종료
    
} // LocationManager 종료

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
