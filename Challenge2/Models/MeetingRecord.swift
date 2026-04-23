//
//  MeetingRecord.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/21/26.
//

import Foundation
import SwiftData

@Model
class MeetingRecord {
    
    var id: UUID
    var name: String
    var session: String
    var category: String
    
    var activity: String
    var placeName: String
    var latitude: Double
    var longitude: Double

    var createdAt: Date
    
    init(name: String, session: String, category: String){
        self.id = UUID()
        self.name = name
        self.session = session
        self.category = category
        
        self.activity = ""
        self.placeName = ""
        self.latitude = 0.0
        self.longitude = 0.0
        
        self.createdAt = Date()
    }
}
