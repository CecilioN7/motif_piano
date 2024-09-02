//
//  PianoView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//
import SwiftUI

struct PianoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // White keys
            HStack(spacing: 0) {
                ForEach(NOTES.filter { !$0.contains("b") }, id: \.self) { note in
                    KeyView(note: note, isBlack: false)
                }
            }
            // Black keys
            HStack(spacing: 0) {
                ForEach(NOTES.filter { $0.contains("b") }, id: \.self) { note in
                    KeyView(note: note, isBlack: true)
                        .offset(x: getOffset(for: note))
                }
            }
        }
        .padding()
    }
    
    private func getOffset(for note: String) -> CGFloat {
        let octaveIndex = Int(String(note.last!))! - 1 // Get the octave number (1 to 4) and convert to index (0 to 3)
        let baseOffset: CGFloat = CGFloat(octaveIndex) * 110 // Each octave spans 210 points (7 white keys * 30)

        switch note.prefix(note.count - 1) { // Extract note name without octave number
        case "Db":
            return baseOffset + 15  // Halved offset from 30
        case "Eb":
            return baseOffset + 35  // Halved offset from 70
        case "Gb":
            return baseOffset + 65  // Halved offset from 130
        case "Ab":
            return baseOffset + 80  // Halved offset from 160
        case "Bb":
            return baseOffset + 95  // Halved offset from 190
        default:
            return 0
        }
    }
}

#Preview {
    PianoView()
}
