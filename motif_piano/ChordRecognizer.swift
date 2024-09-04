//
//  ChordRecognizer.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//

import Foundation

class ChordRecognizer {
    // Normalizes notes to pitch classes (0-11), removes duplicates, and sorts them
    private func normalizeNotes(_ notes: [Int]) -> [Int] {
        return Array(Set(notes.map { $0 % 12 })).sorted()
    }

    // Converts a pitch class (0-11) to its corresponding note name
    private func noteName(for pitchClass: Int) -> String {
        let noteNames = ["C", "C#", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
        return noteNames[pitchClass % 12]
    }

    // Chord formulas defined by intervals (semitones from the root note)
    private let chordFormulas: [String: [Int]] = [
        // Intervals
        "minor 2nd": [0, 1],           // Minor 2nd
        "Major 2nd": [0, 2],           // Major 2nd
        "minor 3rd": [0, 3],           // Minor 3rd
        "Major 3rd": [0, 4],           // Major 3rd
        "Perfect 4th": [0, 5],         // Perfect 4th
        "Tritone": [0, 6],             // Tritone (Augmented 4th / Diminished 5th)
        "Perfect 5th": [0, 7],         // Perfect 5th
        "minor 6th": [0, 8],           // Minor 6th (interval)
        "Major 6th": [0, 9],           // Major 6th (interval)
        "minor 7th": [0, 10],          // Minor 7th (interval)
        "Major 7th": [0, 11],          // Major 7th (interval)
        "Octave": [0, 0],              // Octave (interval within the same pitch class)

        // Triads
        "": [0, 4, 7],                 // Major
        "minor": [0, 3, 7],            // Minor
        "aug": [0, 4, 8],              // Augmented chord
        "dim": [0, 3, 6],              // Diminished chord

        // Seventh Chords
        "7": [0, 4, 7, 10],            // Dominant 7th
        "min7": [0, 3, 7, 10],         // Minor 7th
        "Maj7": [0, 4, 7, 11],         // Major 7th
        "minMaj7": [0, 3, 7, 11],      // Minor Major 7th
        "dim7": [0, 3, 6, 9],          // Diminished 7th chord
        "aug7": [0, 4, 8, 10],         // Augmented 7th chord
        "min7b5": [0, 3, 6, 10],       // Minor 7th flat 5

        // Extended Chords
        "9": [0, 2, 4, 7, 10],         // Dominant 9th chord
        "min9": [0, 2, 3, 7, 10],      // Minor 9th chord
        "Maj9": [0, 2, 4, 7, 11],      // Major 9th chord
        "11": [0, 4, 7, 10, 2, 5],     // Dominant 11th chord
        "min11": [0, 3, 7, 10, 2, 5],  // Minor 11th chord
        "Maj11": [0, 2, 4, 7, 11, 5],  // Major 11th chord
        "13": [0, 2, 4, 7, 10, 5, 9],  // Dominant 13th chord
        "min13": [0, 2, 3, 7, 10, 5, 9], // Minor 13th chord
        "Maj13": [0, 2, 4, 7, 11, 5, 9], // Major 13th chord

        // Suspended and Altered Chords
        "sus": [0, 5, 7],              // Suspended chord (e.g., Csus4)
        "7-5": [0, 4, 6, 10],          // Dominant 7th flat 5 chord
        "7+5": [0, 4, 8, 10],          // Dominant 7th sharp 5 chord

        // Other Chords
        "5": [0, 7],                   // Perfect 5th (Power chord)
        "Maj6": [0, 4, 7, 9],          // Major 6th chord
        "min6": [0, 3, 7, 9],          // Minor 6th chord
        "6/9": [0, 2, 4, 7, 9],        // 6/9 chord
        "add": [0, 4, 7, 2]            // Add chord (e.g., Cadd9)
    ]

    // Detects chord based on normalized active notes
    func detectChord(from notes: [Int]) -> (mainChord: String?, alternateChords: [String]) {
        guard !notes.isEmpty else { return (nil, []) }

        let normalizedNotes = normalizeNotes(notes)
        print("Normalized Notes: \(normalizedNotes)") // Debug: print normalized notes
        
        // Try each note as a potential root note
        var detectedChords: [(name: String, root: Int)] = []

        for rootNote in normalizedNotes {
            let intervals = normalizedNotes.map { ($0 - rootNote + 12) % 12 }.sorted()
            print("Root Note: \(noteName(for: rootNote)), Intervals: \(intervals)") // Debug: print intervals

            // Check for the special case of an octave (same pitch class, different octaves)
            if intervals.count == 1 && notes.count > 1 {
                let octaveCount = notes.map { $0 % 12 }.filter { $0 == rootNote }.count
                if octaveCount > 1 {
                    detectedChords.append((name: "Octave", root: rootNote))
                    continue
                }
            }

            // Match the intervals against the chord formulas
            for (chordName, formula) in chordFormulas where intervals == formula {
                print("Matched Chord: \(noteName(for: rootNote)) \(chordName)") // Debug: print matched chord
                detectedChords.append((name: chordName, root: rootNote))
            }
        }

        guard let firstChord = detectedChords.first else {
            return (nil, [])
        }

        let mainChord = "\(noteName(for: firstChord.root)) \(firstChord.name)"
        let alternateChords = detectedChords.dropFirst().map { "\(noteName(for: $0.root)) \($0.name)" }

        return (mainChord, alternateChords)
    }
}
