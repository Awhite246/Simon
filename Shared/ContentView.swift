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
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(225)), GridItem(.fixed(225))], content: {
            ForEach(0..<4) { num in
                colorDisplay[num]
                    .opacity(flash[num] ? 1 : 0.4)
                    .onTapGesture {
                        flashColorDisplay(index: num)
                    }
            }
        })
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
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
