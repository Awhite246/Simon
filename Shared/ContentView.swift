//
//  ContentView.swift
//  Shared
//
//  Created by Alistair White on 9/8/22.
//

import SwiftUI

struct ContentView: View {
    @State var correct = true
    @State private var colorDisplay = [ColorDisplay(color: .green), ColorDisplay(color: .red), ColorDisplay(color: .yellow), ColorDisplay(color: .blue)]
    @State private var flash = [false, false, false, false]
    @State private var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var sequence = [Int]()
    @State private var userIndex = 0
    @State private var playing = false
    @State private var text = "Start"
    @State private var startGame = false
    @State private var score = 0
    var body: some View {
        ZStack {
            //lets player start the timer and start playing
            Button {
                text = ""
                startGame.toggle()
                index = 1
                sequence.append(Int.random(in: 0...3))
                flashColorDisplay(index: sequence.last!)
            } label: {
                Text(text)
            }
            
            //shows the buttons on the screen
            LazyVGrid(columns: [GridItem(.fixed(225)), GridItem(.fixed(225))], content: {
                ForEach(0..<4) { num in
                    colorDisplay[num]
                        .opacity(flash[num] ? 1 : 0.4)
                    //increments player taps when button clicked
                        .onTapGesture {
                            if playing {
                                flashColorDisplay(index: num)
                                userIndex += 1
                                //checks how many clicks left
                                if userIndex >= sequence.count - 1{
                                    playing = false
                                    userIndex = 0
                                }
                                //checks if correct click
                                if num != sequence[userIndex] {
                                    startGame = false
                                    playing = false
                                }
                            }
                        }
                }
            })
            .preferredColorScheme(.dark)
            .onReceive(timer) { _ in
                if startGame { //checks if game has started
                    if playing { //checks if player is allowed to click
                        
                    } else {
                        if index < sequence.count {
                            flashColorDisplay(index: sequence[index])
                            index += 1
                        } else {
                            index = 0
                            sequence.append(Int.random(in: 0...3))
                            playing = true
                        }
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
    func flashColorDisplay(index: Int) {
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
            
        }
    }
}

struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 200, height: 430, alignment: .center)
            .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
