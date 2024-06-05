//
//  ContentView.swift
//  WordScramble
//
//  Created by Buhle Radzilani on 2024/06/05.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    
    var body: some View {
        
        NavigationView{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                }
                
                Section{
                    ForEach(usedWords, id: \.self) {word in
                        Text(word)
                        
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
        }
    }
    
    func addNewWord(){
        
        //trimming the white space to avoid white space being used as a character.
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //answer must be greater than zero or else break method meaning we don't want to submit an empty String.
        guard answer.count > 0 else{return }//checks if the 'answer' string is not empty (its length is greater than 0)
        //the guard keyword ensures that nothing beyond this statement runs function will be broken at this point if count is less than zero
            
            //Extra validation to come
            
            usedWords.insert(answer, at: 0) //answer will be inserted at the beginning of the array.
            newWord = ""
            
        }
        
    }
  

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
