//
//  ContentView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/19/26.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedCategories: [String] = []
    @State private var hasCompletedSelection = false
    
    var body: some View {
        if hasCompletedSelection {
            HomeView(selectedCategories: $selectedCategories)
        } else {
            InterestSelectionView(
            selectedCategories: $selectedCategories,
                hasCompletedSelection: $hasCompletedSelection
            )
        }
    }
}

#Preview {
    ContentView()
}
