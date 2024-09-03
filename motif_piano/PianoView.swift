//
//  PianoView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//
import SwiftUI

struct PianoView: View {
    // Observe the MIDIManager singleton
    @ObservedObject var midiManager = MIDIManager.shared

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
        let octaveIndex = Int(String(note.last!))! - 1
        let baseOffset: CGFloat = CGFloat(octaveIndex) * 110

        switch note.prefix(note.count - 1) {
        case "Db":
            return baseOffset + 15 + 40  // Offset + 40
        case "Eb":
            return baseOffset + 35 + 40  // Offset + 40
        case "Gb":
            return baseOffset + 65 + 40  // Offset + 40
        case "Ab":
            return baseOffset + 80 + 40  // Offset + 40
        case "Bb":
            return baseOffset + 95 + 40  // Offset + 40
        default:
            return 40  // Adding 30 to the default offset
        }
    }

}

#Preview {
    PianoView()
}
