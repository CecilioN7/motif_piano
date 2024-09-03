//
//  MIDIManager.swift
//  motif_piano
//
//  Created by Cecilio Samuel Navarro on 9/2/24.
//

import Foundation
import CoreMIDI
import Combine

class MIDIManager: ObservableObject {
    static let shared = MIDIManager() // Singleton instance

    @Published var noteStates: [Int: (isPressed: Bool, isSustained: Bool)] = [:]
    @Published var isSustainPressed = false // Track sustain pedal state

    private var midiClient = MIDIClientRef()
    private var inputPort = MIDIPortRef()

    private init() {
        for i in 0...127 {
            noteStates[i] = (false, false)
        }
        setupMIDI()
    }

    private func setupMIDI() {
        let clientStatus = MIDIClientCreate("MIDI Client" as CFString, nil, nil, &midiClient)
        guard clientStatus == noErr else {
            print("Error creating MIDI client: \(clientStatus)")
            return
        }

        let inputStatus = MIDIInputPortCreate(midiClient, "Input Port" as CFString, midiReadProc, nil, &inputPort)
        guard inputStatus == noErr else {
            print("Error creating MIDI input port: \(inputStatus)")
            return
        }

        let sourceCount = MIDIGetNumberOfSources()
        for i in 0..<sourceCount {
            let src = MIDIGetSource(i)
            MIDIPortConnectSource(inputPort, src, nil)
        }
    }

    private let midiReadProc: MIDIReadProc = { packetList, srcConnRefCon, connRefCon in
        let midiManager = MIDIManager.shared // Access the singleton instance

        packetList.withMemoryRebound(to: MIDIPacketList.self, capacity: 1) { packetListPointer in
            var packet = packetListPointer.pointee.packet

            for _ in 0..<packetListPointer.pointee.numPackets {
                let midiStatus = packet.data.0
                let midiData1 = Int(packet.data.1)
                let midiData2 = packet.data.2

                if midiStatus == 0xB0 && midiData1 == 64 {
                    DispatchQueue.main.async {
                        midiManager.isSustainPressed = (midiData2 >= 64)
                        if !midiManager.isSustainPressed {
                            for note in midiManager.noteStates.keys {
                                midiManager.noteStates[note]?.isSustained = false
                            }
                        }
                    }
                }

                if midiStatus == 0x90 && midiData2 > 0 {
                    DispatchQueue.main.async {
                        midiManager.noteStates[midiData1]?.isPressed = true
                        midiManager.noteStates[midiData1]?.isSustained = false
                    }
                } else if midiStatus == 0x80 || (midiStatus == 0x90 && midiData2 == 0) {
                    DispatchQueue.main.async {
                        if midiManager.isSustainPressed {
                            midiManager.noteStates[midiData1]?.isSustained = true
                        }
                        midiManager.noteStates[midiData1]?.isPressed = false
                    }
                }

                packet = MIDIPacketNext(&packet).pointee
            }
        }
    }

    // Function to get currently pressed or sustained notes
    func getActiveNotes() -> [Int] {
        return noteStates
            .filter { $0.value.isPressed || ($0.value.isSustained && isSustainPressed) }
            .map { $0.key }
            .sorted()
    }
}


