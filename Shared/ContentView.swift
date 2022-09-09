//
//  ContentView.swift
//  Shared
//
//  Created by Alistair White on 9/8/22.
//

import SwiftUI

struct ContentView: View {
    @State var clickOrder = ""
    var body: some View {
        VStack {
            Text("Current Click Order")
            Text(clickOrder)
                .font(.caption)
                .padding()
            HStack {
                ForEach((1...4), id: \.self) { num in
                    Button(action: {
                        clickOrder += "\(num)"
                    }, label: {
                        Text("\(num)")
                            .padding()
                            .font(.title)
                    })
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
