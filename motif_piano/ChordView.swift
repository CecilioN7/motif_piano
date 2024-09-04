//
//  ChordView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/2/24.
//

import SwiftUI

struct ChordView: View {
    @ObservedObject var midiManager = MIDIManager.shared
    private var chordRecognizer = ChordRecognizer()

    var body: some View {
        HStack {
            let detectedChord = chordRecognizer.detectChord(from: midiManager.getActiveNotes())
            
            if let mainChord = detectedChord.mainChord {
                Text(mainChord)
                    .font(.largeTitle)
                    .bold()
                
                // Display alternate chord names if any
                if !detectedChord.alternateChords.isEmpty {
                    HStack {
                        ForEach(detectedChord.alternateChords, id: \.self) { alternateChord in
                            Text(alternateChord)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            // The view is fixed in size even when no chord is detected
        }
        .frame(height: 0) // Set the fixed size for the view
        .padding()
        .onReceive(midiManager.$noteStates) { _ in
            // Trigger view update whenever noteStates change
        }
    }
}

#Preview {
    Group {
        ChordView()
    }
}
