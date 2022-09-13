//
//  ContentView.swift
//  Shared
//
//  Created by Alistair White on 9/8/22.
//

import SwiftUI

struct ContentView: View {
    @State private var colorDisplay = [ColorDisplay(color: .green), ColorDisplay(color: .red), ColorDisplay(color: .yellow), ColorDisplay(color: .blue)]
    @State var correct = true
    var body: some View {
        LazyVGrid(columns: [GridItem(.fixed(225)), GridItem(.fixed(225))], content: {
            ForEach(0..<4) { num in
                colorDisplay[num]
            }
        })
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
    
}

struct ColorDisplay: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(color)
            .frame(width: 200, height: 450, alignment: .center)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
