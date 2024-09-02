//
//  KeyView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//

import SwiftUI

let NOTES = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]

struct KeyView: View {
    var body: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: 60, height: 300)
            .border(Color.black, width: 2)
//        Text("Key!")
//            .font(.headline)
//            .padding()
//            .background(Color.gray)
//            .cornerRadius(5.0)
    }
}

#Preview {
    KeyView()
}
