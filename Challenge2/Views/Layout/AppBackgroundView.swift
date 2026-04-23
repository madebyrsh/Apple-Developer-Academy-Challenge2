//
//  AppBackgroundView.swift
//  Challenge2
//
//  Created by Shayne Ryu on 4/20/26.
//

import SwiftUI

struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            // 배경이미지 삽입
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
        }// ZStack 끝
    }
}

#Preview {
    AppBackgroundView()
}
