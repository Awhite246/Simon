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
    @State private var begin = false
    var body: some View {
        ZStack {
            Button {
                text = ""
                begin = true
            } label: {
                Text(text)
            }


            LazyVGrid(columns: [GridItem(.fixed(225)), GridItem(.fixed(225))], content: {
                ForEach(0..<4) { num in
                    colorDisplay[num]
                        .opacity(flash[num] ? 1 : 0.4)
                        .onTapGesture {
                            if playing {
                                flashColorDisplay(index: num)
                                userIndex += 1
                            }
                        }
                }
            })
            .preferredColorScheme(.dark)
            .onReceive(timer) { _ in
                if begin == true {
                    if playing {
                        if userIndex >= sequence.count - 1{
                            playing = false
                            userIndex = 0
                        }
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
