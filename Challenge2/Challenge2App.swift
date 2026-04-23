//
//  Challenge2App.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/19/26.
//

import SwiftUI
import SwiftData

@main
struct Challenge2App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: MeetingRecord.self)
    }
}
