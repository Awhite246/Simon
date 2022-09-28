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
    @State private var timer = Timer.publish(every: 0.20, on: .main, in: .common).autoconnect()
    @State private var index = 0
    @State private var sequence = [Int]()
    @State private var userIndex = 0
    @State private var playing = true
    @State private var text = "Start"
    @State private var startGame = false
    @State private var wait = 0
    var body: some View {
        ZStack {
            VStack {
                //lets player start the timer and start playing
                //                Button {
                //                    text = ""
                //                    index = 0
                //                    sequence.append(Int.random(in: 0...3))
                //                    flashColorDisplay(index: sequence[index])
                //                    startGame = true
                //                } label: {
                //                    Text(text)
                //                }
                //Debugging
                Text("Debugging")
                Text("Sequence count: \(sequence.count), User index: \(userIndex)")
                Text("index: \(index), playing: \(playing ? "true" : "false")")
                Text("startgame : \(startGame ? "true" : "false")")
                Text("wait: \(wait)")
                Text("score: \(sequence.count)")
            }
            //shows the buttons on the screen
            LazyVGrid(columns: [GridItem(.fixed(212)), GridItem(.fixed(212))], content: {
                ForEach(0..<4) { num in
                    colorDisplay[num]
                        .opacity(flash[num] ? 1 : 0.4)
                    //increments player taps when button clicked
                        .onTapGesture {
                            if startGame && playing {
                                flashColorDisplay(index: num)
                                //checks if correct click
                                if num != sequence[userIndex] {
                                    //restart game
                                    startGame = false
                                    playing = false
                                }
                                userIndex += 1
                                //checks how many clicks left
                                if userIndex >= sequence.count{
                                    userIndex = 0
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
                        
                    } else if wait == calcDelay(time: sequence.count) {
                        if index < sequence.count{
                            flashColorDisplay(index: sequence[index])
                            index += 1
                        } else {
                            index = 0
                            sequence.append(Int.random(in: 0...3))
                            flashColorDisplay(index: sequence.last!)
                            wait = 0
                            playing = true
                        }
                        wait = 0
                    } else {
                        wait += 1
                    }
                }
            }
            //Start Button
            if !startGame {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 250)
                    Circle()
                        .trim(from: 0, to: 0.25)
                        .fill(Color.blue)
                        .frame(width: 230)
                    Circle()
                        .trim(from: 0.25, to: 0.5)
                        .fill(Color.yellow)
                        .frame(width: 230)
                    Circle()
                        .trim(from: 0.5, to: 0.75)
                        .fill(Color.green)
                        .frame(width: 230)
                    Circle()
                        .trim(from: 0.75, to: 1)
                        .fill(Color.red)
                        .frame(width: 230)
                    Circle()
                        .fill(Color.black)
                        .frame(width: 210)
                    Text("Start")
                        .font(.system(size: 50))
                }
                .onTapGesture {
                    index = 0
                    playing = true
                    userIndex = 0
                    sequence.removeAll()
                    wait = 0
                    sequence.append(Int.random(in: 0...3))
                    flashColorDisplay(index: sequence[index])
                    startGame = true
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func flashColorDisplay(index: Int) {
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
            
        }
    }
    
    func calcDelay(time : Int) -> Int {
        if time <= 5 {
            return 3
        } else if time <= 10 {
            return 2
        } else {
            return 1
        }
    }
}
struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 210, height: 430, alignment: .center)
            .padding(0.5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
