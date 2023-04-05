//
//  PreviousRolls.swift
//  DiceRoll
//
//  Created by Öznur Köse on 29.03.2023.
//

import SwiftUI

struct PreviousRolls: View {
    @State var pastValues: [[Int]]
    let columns = [GridItem(.adaptive(minimum: 70))]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                ScrollView(showsIndicators: false) {
                    
                    VStack {
                        ForEach(0..<pastValues.count, id: \.self) { value in
                            VStack {
                                
                                LazyVGrid(columns: columns, alignment: .center) {
                                    ForEach(0..<pastValues[value].count, id: \.self) { val in
                                        DiceView(num: pastValues[value][val])
                                    }
                                }
                                Divider()
                                    .background(.secondary)
                                    
                                
                            }
                         
                        }
                    }
                    .padding(.top, 100)
                    .padding()
                    
                }
                
                
                
            }
            .ignoresSafeArea()
            .onAppear(perform: readData)
            
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
    
}

struct PreviousRolls_Previews: PreviewProvider {
    static var previews: some View {
        PreviousRolls(pastValues: [[1, 4], [5, 3], [2, 1]])
    }
}
