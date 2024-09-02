// KeyView.swift
import SwiftUI

let NOTES = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]

struct KeyView: View {
    var note: String
    var isBlack: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(isBlack ? Color.black : Color.white)
                .frame(width: isBlack ? 40 : 60, height: isBlack ? 200 : 300)
                .border(Color.black, width: 20)
            if !isBlack {
                Text(note)
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top, 200)
            }
        }
        .zIndex(isBlack ? 1 : 0) // Make sure black keys appear on top
    }
}

#Preview {
    Group {
        KeyView(note: "C", isBlack: false)
        KeyView(note: "Db", isBlack: true)
    }
}

