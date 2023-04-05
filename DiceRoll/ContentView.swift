//
//  ContentView.swift
//  DiceRoll
//
//  Created by Öznur Köse on 28.03.2023.
//

import CoreHaptics
import SwiftUI



struct ContentView: View {
   
    
    var body: some View {
        TabView {
            DiceRoll()
                .tabItem {
                    Label("Dice Roll", systemImage: "die.face.6")
                }
            
            PreviousRolls(pastValues: [[10, 5]])
                .tabItem {
                    Label("History", systemImage: "book")
                }
        }
        
    }
}
struct
ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
