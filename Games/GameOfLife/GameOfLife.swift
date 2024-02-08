//
//  GameOfLife.swift
//  Games
//
//  Created by Jack Finnis on 03/02/2023.
//

import SwiftUI
import Combine

let size = 100

struct GameOfLife: View {
    @StateObject var vm = GameOfLifeVM()
    
    var body: some View {
        Color.clear
            .overlay {
                HStack(spacing: 0) {
                    ForEach(0..<size, id: \.self) { row in
                        VStack(spacing: 0) {
                            ForEach(0..<size, id: \.self) { col in
                                (vm.today[row][col] ? Color.black : .white)
                                    .frame(width: 10, height: 10)
                                    .onTapGesture {
                                        vm.today[row][col].toggle()
                                    }
                            }
                        }
                    }
                }
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    vm.randomDay()
                    Haptics.tap()
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .font(.title2)
                .padding()
            }
    }
}

#Preview {
    GameOfLife()
}

class GameOfLifeVM: ObservableObject {
    @Published var today = [[Bool]]()
    var timer: Cancellable?
    
    init() {
        randomDay()
        timer = Timer.publish(every: 0.1, on: .main, in: .default).autoconnect().sink { _ in
            self.next()
        }
    }
    
    func randomDay() {
        today = (1...size).map { _ in
            (1...size).map { _ in Bool.random() }
        }
    }
    
    func next() {
        var tomorrow = [[Bool]](repeating: [Bool](repeating: false, count: size), count: size)
        
        for row in 0..<size {
            for col in 0..<size {
                var count = 0
                for i in -1...1 {
                    for j in -1...1 {
                        if row + i >= 0 && row + i < size && col + j >= 0 && col + j < size && !(i == 0 && j == 0) && self.today[row + i][col + j] {
                            count += 1
                        }
                    }
                }
                
                if self.today[row][col] {
                    if count == 2 || count == 3 {
                        tomorrow[row][col] = true
                    }
                } else {
                    if count == 3 {
                        tomorrow[row][col] = true
                    }
                }
            }
        }
        
        today = tomorrow
    }
}
