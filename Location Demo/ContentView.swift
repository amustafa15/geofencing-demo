//
//  ContentView.swift
//  Location Demo
//
//  Created by Ameen Mustafa on 11/11/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var isInZone: LocationListener
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Where in the world is Carmen San Diego? ")
            Text("\(isInZone.isInZone ? "she is at the pyramids of giza" : "she is NOT at the pyramids of giza" )")
//            Button(action: {
//                isInZone.isInZone.toggle()
//            }) {
//                Text("\(isInZone.isInZone ? "leave the pyramid" : "enter the pyramid" )")
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isInZone.isInZone ? Color.green : Color.red)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
