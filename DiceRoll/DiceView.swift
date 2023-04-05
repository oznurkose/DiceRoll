//
//  DiceView.swift
//  DiceRoll
//
//  Created by Öznur Köse on 29.03.2023.
//

import SwiftUI

struct DiceView: View {
    var num: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.blue)
                .frame(width: 70, height: 70)
                .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(lineWidth: 2)
                )
                
            
            Text("\(num)")
                .font(.title)
                .foregroundColor(.white)
        }
        
            
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        DiceView(num: 5)
    }
}
