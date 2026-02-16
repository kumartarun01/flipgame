//
//  ContentView.swift
//  flipgame
//
//  Created by iMac1 on 16/02/26.
//

import SwiftUI

struct CardModel: Identifiable {
    let id = UUID()
    let name: String
    var isMatched: Bool = false
    var isFaceUp: Bool = false
}

struct ContentView: View {
    
    @State private var cards: [CardModel] = []
    @State private var Selection1: Int? = nil
    
    let cardNames = ["1","2"]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init() {
        _cards = State(initialValue: newCard())
    }
    
    var body: some View {
      
        NavigationStack {
            HStack {
                Button {
                    restartGame()
                } label: {
                    Image(systemName: "restart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                Text("Match The Deck Game")
                    .font(.largeTitle)
                    .padding()
                    .bold()
            }
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(cards.indices, id: \.self) { index in
                    
                    ZStack {
                        if cards[index].isFaceUp || cards[index].isMatched {
                            Image(cards[index].name)
                                .resizable()
                                .scaledToFit()
                                .padding(10)
                                .background(Color.white)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                        }
                        
                    }
                    .frame(height: 200)
                    .onTapGesture {
                        handleCardTap(index: index)
                    }

                }
            }
        }
    }
    func newCard() -> [CardModel] {
        var newCards: [CardModel] = []
        
        for name in cardNames {
            newCards.append(CardModel(name: name))
            newCards.append(CardModel(name: name))
        }
        return newCards.shuffled()
    }
    
    func handleCardTap(index: Int) {
        
        if cards[index].isMatched || cards[index].isFaceUp {
            return
        }
        
        cards[index].isFaceUp = true
        
        if let firstIndex = Selection1 {
            if cards[firstIndex].name == cards[index].name {
                cards[firstIndex].isMatched = true
                cards[index].isMatched = true
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.cards[firstIndex].isFaceUp = false
                    self.cards[index].isFaceUp = false
                }
            }
            Selection1 = nil
        } else {
            Selection1 = index
        }
        
    }
    
    func restartGame() {
        cards = newCard()
        Selection1 = nil
    }
    
}


#Preview {
    ContentView()
}
