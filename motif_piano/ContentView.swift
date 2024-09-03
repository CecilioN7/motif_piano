//
//  ContentView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ChordView()
            PianoView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
