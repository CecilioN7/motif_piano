//
//  ContentView.swift
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
    // Observe the MIDIManager singleton
    @ObservedObject var midiManager = MIDIManager.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(getRectangleColor(note: note))
                .frame(width: isBlack ? 20 : 30, height: isBlack ? 100 : 150)
                .border(Color.black, width: 0.5)
            
            if !isBlack {
                Text(note.dropLast()) // Remove the octave number for display
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 10))
                    .padding(.top, 100)
            }
        }
        .zIndex(isBlack ? 1 : 0)
    }

    // Function to determine the color of each key based on its state
    private func getRectangleColor(note: String) -> Color {
        let midiNoteNumber = getMIDINoteNumber(note: note)
        let state = midiManager.noteStates[midiNoteNumber]

        if state?.isPressed ?? false {  // If the key is currently pressed
            return .blue // Dark blue color when actively pressed
        } else if state?.isSustained ?? false && midiManager.isSustainPressed {  // If the key is sustained and sustain pedal is pressed
            return .cyan // Solid light blue color when sustained (use 'cyan' or any solid light blue color)
        } else {
            return isBlack ? .black : .white // Default color: black for black keys, white for white keys
        }
    }


    // Function to map note names to MIDI note numbers
    private func getMIDINoteNumber(note: String) -> Int {
        let noteName = note.dropLast()
        let octave = Int(note.last!.description)!
        let baseNotes = ["C": 0, "Db": 1, "D": 2, "Eb": 3, "E": 4, "F": 5, "Gb": 6, "G": 7, "Ab": 8, "A": 9, "Bb": 10, "B": 11]
        return (octave + 1) * 12 + baseNotes[String(noteName)]!
    }
}

#Preview {
    Group {
        KeyView(note: "C1", isBlack: false)
        KeyView(note: "Db1", isBlack: true)
    }
}

