//
//  KeyView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//
import SwiftUI

// Extending the NOTES array to cover from C1 to G7
let OCTAVES = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
let NOTES = (1...7).flatMap { octave in
    OCTAVES.map { "\($0)\(octave)" }
} + ["C8"] // Adding up to G8 to complete the range

struct KeyView: View {
    var note: String
    var isBlack: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isBlack ? Color.black : Color.white)
                .frame(width: isBlack ? 20 : 30, height: isBlack ? 100 : 150) // Keep original dimensions
                .border(Color.black, width: 0.5) // Keep original border width
            if !isBlack {
                Text(note.dropLast()) // Remove the octave number for display
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 10)) // Keep original font size
                    .padding(.top, 100) // Keep original padding
            }
        }
        .zIndex(isBlack ? 1 : 0) // Make sure black keys appear on top
    }
}

#Preview {
    Group {
        KeyView(note: "C1", isBlack: false)
        KeyView(note: "Db1", isBlack: true)
    }
}
