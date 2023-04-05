//
//  DiceRoll.swift
//  DiceRoll
//
//  Created by Öznur Köse on 4.04.2023.
//

import CoreHaptics
import SwiftUI

struct DiceRoll: View {
    // dice face
    var diceFace = [6, 10, 20, 50, 100]
    @State var selectedDiceFace = 6
    var dice: [Int] {
        Array(1...selectedDiceFace)
    }
    // dice number
    @State var diceNumber = 1
    // past values
    @State var pastValues = [[Int]]()
    @State var lastDice = Array(repeating: 0, count: 1)
    // haptic
    @State var engine: CHHapticEngine?
    // timer
    var timer = Timer.publish(every: 0.09, on: .main, in: .common).autoconnect()
    @State private var timerCountdown = -1
    // grid
    let columns = [GridItem(.adaptive(minimum: 70))]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                Form {
                    Section("Number of face in dice") {
                        // title
                        Picker("How many face of dice you want?", selection: $selectedDiceFace) {
                            ForEach(diceFace, id: \.self) { num in
                                Text("\(num)")
                            }
                        }
                        .pickerStyle(.segmented)
                        
                    }
                    Section("Number of dice") {
                        Stepper("\(diceNumber)", value: $diceNumber, in: 1...8)
                    }
                    
                    
                    Button {
                        lastDice = Array(repeating: 0, count: diceNumber)
                        timerCountdown = 10
                        haptic()
                        
                        
                    } label: {
                        Label("Roll a Dice", systemImage: "dice.fill")
                    }
                    
                    Section {
                        Text("Total Number: \(lastDice.reduce(0, +))")
                            .foregroundColor(.secondary)
                            .font(.headline)
                        LazyVGrid(columns: columns) {
                            ForEach(0..<lastDice.count, id: \.self) { value in
                                DiceView(num: lastDice[value])
                            }
                        }
                        
                    }
                    
                    
                }
                .navigationTitle("DiceRoll")
                
            }
            .onReceive(timer) { _ in
                if timerCountdown >= 1 {
                    timerCountdown -= 1
                    for number in 1...diceNumber {
                        
                        lastDice[number - 1] = dice.randomElement()!
                        
                    }
                    if timerCountdown == 0 {
                        pastValues.insert(lastDice, at: 0)
                        print("Last dice is: \(lastDice)")
                        saveData(pastValues)
                    }
                }
            }
        }
        .onAppear(perform: prepareHaptic)
        .onAppear(perform: readData)
        
        
    }
    
    
    func saveData(_ pastValues: [[Int]]) {
        do {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("diceRolls.json")
            try JSONEncoder().encode(pastValues).write(to: fileURL)
        }
        catch {
            print(error.localizedDescription)
            print("Error saving data")
        }
    }
    
    func readData() {
        do {
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("diceRolls.json")
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([[Int]].self, from: data)
            pastValues = decoded
        }
        
        catch {
            print(error.localizedDescription)
            print("Error reading data")
        }
    }
    
    func prepareHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        }
        
        catch {
            print("Engine could not start: \(error.localizedDescription)")
        }
    }
    
    func haptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        }
        
        catch {
            print("Failed to play haptic event: \(error.localizedDescription)")
        }
    }
}

struct DiceRoll_Previews: PreviewProvider {
    static var previews: some View {
        DiceRoll()
    }
}
