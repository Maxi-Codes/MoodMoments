//
//  CheckAnimationView.swift
//  MoodMoments
//
//  Created by Maximilian Dietrich on 22.07.25.
//

import SwiftUI

struct CheckAnimationView: View {
    @Binding var message: String
    @Binding var show: Bool
    
    @State private var scale: CGFloat = 0.1
    @State private var drawCheck = false
    
    var body: some View {
        if show {
            ZStack {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 120, height: 120)
                            .shadow(radius: 10)
                        
                        CheckMarkShape()
                            .trim(from: 0, to: drawCheck ? 1 : 0)
                            .stroke(Color.green, lineWidth: 6)
                            .frame(width: 60, height: 60)
                            .animation(.easeOut(duration: 0.5), value: drawCheck)
                    }
                    
                    Text(message)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        scale = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        drawCheck = true
                    }
                }
                .onDisappear {
                    scale = 0.1
                    drawCheck = false
                }
            }
            .transition(.opacity)
        }
    }
}

struct CheckMarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let start = CGPoint(x: rect.minX + rect.width * 0.2, y: rect.midY)
        let mid = CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.2)
        let end = CGPoint(x: rect.maxX - rect.width * 0.2, y: rect.minY + rect.height * 0.2)
        
        path.move(to: start)
        path.addLine(to: mid)
        path.addLine(to: end)
        
        return path
    }
}
