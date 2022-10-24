//
//  ContentView.swift
//  Shared
//
//  Created by Alistair White AND Dylan Koehlur on 9/8/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    //sequence and sequence position tracking variables
    @State private var colorDisplay = [ColorDisplay(color: .green), ColorDisplay(color: .red), ColorDisplay(color: .yellow), ColorDisplay(color: .blue)]
    @State private var flash = [false, false, false, false]
    @State private var index = 0
    @State private var sequence = [Int]()
    @State private var userIndex = 0
    
    //play state tracking variables
    @State private var playing = false
    @State private var startGame = false
    @State private var restartGame = false
    
    @State private var wait = 0
    
    //highscore tracking variables
    @State private var highScore = 0
    @State private var newHighScore = false
    
    //animation varaiables
    @State private var highScoreFont = 25.0
    @State private var rainbowColor = 0
    let timer = Timer.publish(every: 0.20, on: .main, in: .common).autoconnect()
    
    //sounds
    @ObservedObject private var sound0 = AudioPlayer(name: "0", type: "wav")
    @ObservedObject private var sound1 = AudioPlayer(name: "1", type: "wav")
    @ObservedObject private var sound2 = AudioPlayer(name: "2", type: "wav")
    @ObservedObject private var sound3 = AudioPlayer(name: "3", type: "wav")
    @ObservedObject private var soundScore = AudioPlayer(name: "HighScore", type: "wav")
    @ObservedObject private var soundLose = AudioPlayer(name: "Lose", type: "wav")
    @ObservedObject private var soundStart = AudioPlayer(name: "Start", type: "wav")
    
    var body: some View {
        ZStack {
            Text(debug(isDebugging: false))
            
            //shows the buttons on the screen
            LazyVGrid(columns: [GridItem(.fixed(212)), GridItem(.fixed(212))], content: {
                ForEach(0..<4) { num in
                    colorDisplay[num]
                        .opacity(flash[num] ? 1 : 0.4)
                    //increments player taps when button clicked
                        .onTapGesture {
                            if startGame && playing {
                                //checks if correct click
                                if num != sequence[userIndex] {
                                    //restart game
                                    startGame = false
                                    playing = false
                                    //checks if new highscore
                                    if highScore < sequence.count {
                                        highScore = sequence.count
                                        newHighScore = true
                                        playSound(name: "HighScore")
                                        //boncy animation when new highscore
                                        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 2)){
                                            highScoreFont = 72
                                        }
                                    } else {
                                        playSound(name: "Lose")
                                    }
                                    restartGame = true
                                    //stops running rest of code to save time
                                    return
                                }
                                flashColorDisplay(index: num)
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
                        
                    } else if wait == calcDelay(time: sequence.count, first: index == 0) { //wait delayed time for user expereince
                        if index < sequence.count{
                            //fashes the colors in the sequence
                            flashColorDisplay(index: sequence[index])
                            index += 1
                        } else {
                            //switches to allowing player to tap
                            switchToPlayer()
                        }
                        wait = 0
                    } else {
                        //updating wait time
                        wait += 1
                    }
                }
                //rainbow highscore animation
                rainbowColor += 1
            }
            //Start / Restart Screen
            Color.black
                .opacity(!startGame || restartGame ? 0.75 : 0)
            VStack {
                Group {
                    //win lose screen
                    Text(newHighScore ? "New Highscore" : "Highscore")
                        .font(.system(size: highScoreFont))
                        .foregroundColor(newHighScore ? calcRainbow(num: rainbowColor) : .white)
                        .multilineTextAlignment(.center)
                    Text("\(highScore)")
                        .font(.system(size: highScoreFont * 2))
                        .padding(.bottom)
                        .foregroundColor(newHighScore ? calcRainbow(num: rainbowColor + 2) : .white)
                }
                //start game again buttons
                if restartGame {
                    Text("Score")
                        .font(.system(size: 25))
                    Text("\(sequence.count)")
                        .padding(.bottom)
                        .font(.system(size: 50))
                    Button("Try Again") {
                        resetValues()
                    }
                    .font(.system(size: 25))
                }
                if !startGame && !restartGame {
                    Button("Play Game") {
                        resetValues()
                    }
                    .font(.system(size: 25))
                }
            }
            //hides screen when playing
            .opacity(!startGame || restartGame ? 1 : 0)
        }
        .ignoresSafeArea()
        
    }
    //flashes colors and plays soiund
    func flashColorDisplay(index: Int) {
        flash[index].toggle()
        withAnimation(.easeInOut(duration: 0.5)) {
            flash[index].toggle()
            playSound(name: "\(index)")
        }
    }
    //calculates delay time between each flash
    func calcDelay(time : Int, first : Bool) -> Int {
        var out = 0
        if first {
            out += 1
        }
        if time <= 5 {
            out += 4
        } else if time <= 15 {
            out += 2
        } else {
            out += 1
        }
        return out
    }
    //plays specified sound
    func playSound(name : String) {
        switch (name) {
        case "0":
            sound0.start()
        case "1":
            sound1.start()
        case "2":
            sound2.start()
        case "3":
            sound3.start()
        case "HighScore":
            soundScore.start()
        case "Lose":
            soundLose.start()
        case "Start":
            soundStart.start()
        default:
            return
        }
    }
    //resets all variables to default values to restart game
    func resetValues() {
        sequence.removeAll()
        startGame = true
        restartGame = false
        newHighScore = false
        highScoreFont = 25.0
        userIndex = 0
        index = 0
        wait = 0
        playing = false
        playSound(name: "Start")
    }
    //sets all variables to let player tap
    func switchToPlayer() {
        sequence.append(Int.random(in: 0...3))
        flashColorDisplay(index: sequence.last!)
        userIndex = 0
        index = 0
        wait = 0
        playing = true
    }
    //displays all variables for debugging
    func debug(isDebugging : Bool) -> String {
        if isDebugging {
            return "Debugging" +
            "\nSequence count: \(sequence.count), User index: \(userIndex)" +
            "\nindex: \(index), playing: \(playing ? "true" : "false")" +
            "\nindex: \(index), playing: \(playing ? "true" : "false")" +
            "\nwait: \(wait)" +
            "\nscore: \(sequence.count)"
        }
        return ""
    }
    //calculates which color to flash
    func calcRainbow(num : Int) -> Color {
        switch (num % 4) {
        case 0: return Color.yellow
        case 1: return Color.green
        case 2: return Color.red
        case 3: return Color.blue
        default: return Color.yellow
        }
    }
}
//Generic colored button
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
