// PianoView.swift
import SwiftUI

struct PianoView: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            HStack(spacing: -0) {
                ForEach(NOTES.filter { !$0.contains("b") }, id: \.self) { note in
                    KeyView(note: note, isBlack: false)
                }
            }
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
        switch note {
        case "Db":
            return 30
        case "Eb":
            return 70
        case "Gb":
            return 130
        case "Ab":
            return 160
        case "Bb":
            return 190
        default:
            return 0
        }
    }
}

#Preview {
    PianoView()
}
