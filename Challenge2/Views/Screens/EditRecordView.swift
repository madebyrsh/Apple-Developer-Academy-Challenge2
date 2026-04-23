//
//  EditRecordView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/22/26.
//
import SwiftUI // SwiftUI 화면 구성용
import SwiftData // SwiftData 모델 바인딩용
import MapKit // 지도 썸네일 표시용

struct EditRecordView: View { // EditRecordView 시작
    
    @Bindable var record: MeetingRecord // 수정할 기록 객체
    @Environment(\.dismiss) private var dismiss // 현재 화면 닫기
    
    @StateObject private var locationManager = LocationManager() // 현재 위치 다시 저장용 위치 매니저
    
    let categories: [String] // 카테고리 목록
    let sessions = ["오전", "오후"] // 세션 선택지
    
    var body: some View { // body 시작
        Form { // Form 시작
            
            Section("기본 정보") { // 기본 정보 섹션 시작
                
                TextField("이름 또는 닉네임", text: $record.name) // 이름 수정칸
                
                Picker("세션", selection: $record.session) { // 세션 Picker 시작
                    ForEach(sessions, id: \.self) { session in // 세션 반복 시작
                        Text(session) // 세션 표시
                    } // 세션 반복 종료
                } // 세션 Picker 종료
                
                Picker("카테고리", selection: $record.category) { // 카테고리 Picker 시작
                    ForEach(categories, id: \.self) { category in // 카테고리 반복 시작
                        Text(category) // 카테고리 표시
                    } // 카테고리 반복 종료
                } // 카테고리 Picker 종료
                
            } // 기본 정보 섹션 종료
            
            
            Section("만남 정보") { // 만남 정보 섹션 시작
                
                TextField("어디서 만났나요?", text: $record.placeName) // 장소명 수정칸
                
                TextField("어떤 활동을 했나요?", text: $record.activity, axis: .vertical) // 활동 내용 수정칸
                    .lineLimit(3...6) // 여러 줄 입력 가능
                
            } // 만남 정보 섹션 종료
            
            
            Section("위치 저장") { // 위치 저장 섹션 시작
                
                Button("현재 위치 다시 저장") { // 현재 위치 다시 저장 버튼 시작
                    locationManager.requestCurrentLocation() // 현재 위치 요청
                } // 현재 위치 다시 저장 버튼 종료
                
                if record.latitude != 0.0 && record.longitude != 0.0 { // 저장된 좌표가 있을 때 시작
                    
                    Map( // 지도 썸네일 시작
                        initialPosition: .region(
                            MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: record.latitude,
                                    longitude: record.longitude
                                ), // 저장된 좌표를 지도 중심으로 사용
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.005,
                                    longitudeDelta: 0.005
                                ) // 지도 확대 범위
                            )
                        )
                    ) { // Map 내용 시작
                        Marker(
                            "만난 위치",
                            coordinate: CLLocationCoordinate2D(
                                latitude: record.latitude,
                                longitude: record.longitude
                            )
                        ) // 저장된 위치에 마커 표시
                    } // Map 내용 종료
                    .frame(height: 160) // 지도 높이
                    .clipShape(RoundedRectangle(cornerRadius: 12)) // 둥근 모서리
                    
                } // 저장된 좌표가 있을 때 종료
                
            } // 위치 저장 섹션 종료
            
        } // Form 종료
        .navigationTitle("기록 수정") // 상단 제목
        .navigationBarTitleDisplayMode(.inline) // inline 스타일 제목
        .toolbar { // toolbar 시작
            
            ToolbarItem(placement: .topBarTrailing) { // 오른쪽 상단 버튼 시작
                Button("완료") { // 완료 버튼 시작
                    dismiss() // 현재 화면 닫기
                } // 완료 버튼 종료
            } // 오른쪽 상단 버튼 종료
            
        } // toolbar 종료
        .onReceive(locationManager.$latitude) { value in // 위도 수신 시작
            record.latitude = value // 받아온 위도를 기록에 반영
        } // 위도 수신 종료
        .onReceive(locationManager.$longitude) { value in // 경도 수신 시작
            record.longitude = value // 받아온 경도를 기록에 반영
        } // 경도 수신 종료
        
    } // body 종료
    
} // EditRecordView 종료

#Preview { // Preview 시작
    EditRecordView(
        record: MeetingRecord(name: "사라", session: "오후", category: "일본어"),
        categories: ["일본어", "디자인", "영화"]
    )
} // Preview 종료
