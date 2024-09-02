//
//  PianoView.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/1/24.
//

import SwiftUI

struct PianoView: View {
    var body: some View {
        HStack {
            KeyView()
            KeyView()
            KeyView()
        }
        .padding()
    }
}

#Preview {
    PianoView()
}
