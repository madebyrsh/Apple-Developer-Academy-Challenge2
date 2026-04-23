//
//  RecordDetailView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/23/26.
//

import SwiftUI // SwiftUI 화면 구성용
import MapKit // 지도 썸네일 표시용

struct RecordDetailView: View { // RecordDetailView 시작
    
    @Bindable var record: MeetingRecord // 상세로 보여줄 기록
    
    let categories: [String] // 수정 화면으로 넘길 카테고리 목록
    
    var body: some View { // body 시작
        ScrollView { // ScrollView 시작
            
            VStack(alignment: .leading, spacing: 24) { // 전체 콘텐츠 VStack 시작
                
                VStack(alignment: .leading, spacing: 8) { // 상단 기본 정보 카드 시작
                    
                    Text(record.name) // 이름 표시
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 8) { // 카테고리/세션 표시 시작
                        
                        Text(record.category) // 카테고리 표시
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Capsule())
                        
                        Text("\(record.session) 세션") // 세션 표시
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.15))
                            .clipShape(Capsule())
                        
                    } // 카테고리/세션 표시 종료
                    
                } // 상단 기본 정보 카드 종료
                
                
                VStack(alignment: .leading, spacing: 10) { // 장소 정보 섹션 시작
                    
                    Text("어디서 만났나요") // 섹션 제목
                        .font(.headline)
                    
                    if record.placeName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // 장소명이 비어 있을 때 시작
                        Text("기록된 장소가 없습니다.")
                            .foregroundColor(.gray)
                    } else { // 장소명이 있을 때 시작
                        Text(record.placeName) // 장소명 표시
                            .foregroundColor(.primary)
                    } // 장소명이 있을 때 종료
                    
                } // 장소 정보 섹션 종료
                
                
                if record.latitude != 0.0 && record.longitude != 0.0 { // 위치 좌표가 있을 때 시작
                    
                    VStack(alignment: .leading, spacing: 10) { // 지도 섹션 시작
                        
                        Text("만난 위치") // 지도 섹션 제목
                            .font(.headline)
                        
                        Map( // 지도 썸네일 시작
                            initialPosition: .region(
                                MKCoordinateRegion(
                                    center: CLLocationCoordinate2D(
                                        latitude: record.latitude,
                                        longitude: record.longitude
                                    ), // 저장된 좌표를 지도 중심으로 설정
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
                        .frame(height: 180) // 지도 높이
                        .clipShape(RoundedRectangle(cornerRadius: 16)) // 둥근 모서리 적용
                        
                    } // 지도 섹션 종료
                    
                } // 위치 좌표가 있을 때 종료
                
                
                VStack(alignment: .leading, spacing: 10) { // 활동 정보 섹션 시작
                    
                    Text("어떤 활동을 했나요") // 섹션 제목
                        .font(.headline)
                    
                    if record.activity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { // 활동 내용이 비어 있을 때 시작
                        Text("기록된 활동 내용이 없습니다.")
                            .foregroundColor(.gray)
                    } else { // 활동 내용이 있을 때 시작
                        Text(record.activity) // 활동 내용 표시
                            .foregroundColor(.primary)
                    } // 활동 내용이 있을 때 종료
                    
                } // 활동 정보 섹션 종료
                
                
                VStack(alignment: .leading, spacing: 10) { // 날짜 정보 섹션 시작
                    
                    Text("기록한 날짜") // 섹션 제목
                        .font(.headline)
                    
                    Text(record.createdAt.formatted(date: .abbreviated, time: .shortened)) // 생성일 표시
                        .foregroundColor(.gray)
                    
                } // 날짜 정보 섹션 종료
                
                
                NavigationLink { // 수정 화면으로 이동 시작
                    EditRecordView(
                        record: record,
                        categories: categories
                    )
                } label: { // 수정 버튼 UI 시작
                    Text("기록 수정하기")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.black)
                        .clipShape(RoundedRectangle(cornerRadius: 28))
                } // 수정 버튼 UI 종료
                .buttonStyle(.plain)
                
            } // 전체 콘텐츠 VStack 종료
            .padding(24) // 전체 안쪽 여백
            
        } // ScrollView 종료
        .navigationTitle("기록 상세") // 상단 제목
        .navigationBarTitleDisplayMode(.inline) // 제목 inline 표시
        
    } // body 종료
    
} // RecordDetailView 종료


#Preview { // Preview 시작
    RecordDetailView(
        record: MeetingRecord(name: "사라", session: "오후", category: "일본어"),
        categories: ["일본어", "디자인", "영화"]
    )
} // Preview 종료
