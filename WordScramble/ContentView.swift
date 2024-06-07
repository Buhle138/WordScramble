//
//  ContentView.swift
//  WordScramble
//
//  Created by Buhle Radzilani on 2024/06/05.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    //rootword contains the word that the player has to play from.
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    var body: some View {
        
        NavigationView{
            List{
                Section{
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section{
                    ForEach(usedWords, id: \.self) {word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                        
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addNewWord)
            .onAppear(perform: startGame) //We want to load the file before we can load the user interface.
            .alert(errorTitle, isPresented: $showingError){
                Button("Ok", role: .cancel){}
            }message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord(){
        
        //trimming the white space to avoid white space being used as a character.s
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        //answer must be greater than zero or else break method meaning we don't want to submit an empty String.
        guard answer.count > 0 else{return }//checks if the 'answer' string is not empty (its length is greater than 0)
        //the guard keyword ensures that nothing beyond this statement runs function will be broken at this point if count is less than zero
            
        guard isOriginal(word: answer) else{
            wordError(title: "Word is used already", message: "Be more original")
            return
        }
        guard  isPossible(word: answer) else{
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        
        guard isReal(word: answer) else{
            wordError(title: "Word not recognized", message: "You can't just make them up")
            return
        }
            //Extra validation to come
        withAnimation{
            usedWords.insert(answer, at: 0) //answer will be inserted at the beginning of the array.
        }
            newWord = ""
            
        }
    //what should we do if the program  can't find start.txt file in our app bundle.
    //And if we can't load it what should we do again.
    //We use the fatalError method which handles the error for us just like we did in java
    //FataError will kill the entire application.
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            //loading start words
            
            // this if statement is handling errors after the try? block.
            //this if statement will only run if there are no errors in the startWordsURL. this is what this line of code means in the if statement.
            if let startWords = try? String(contentsOf: startWordsURL){
                let allwords = startWords.components(separatedBy: "\n")
                //randomElement returns an optional string (A string that can have a value or be null).
               //In our case below rootWord is not an optional string so therefore we will need to provide a default value to rootWord of silkworm to cover up that null response.
                rootWord = allwords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("could not load start.txt from bundle.")
        }
    
    //Below we are making sure the user can't enter invalid words.
    //isOriginal is checking if the word hasn't been used before returns true if it was.
    
    func isOriginal(word: String) -> Bool{
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool{
        
        
        var tempword = rootWord
        
        //checking if a random word (rootWord from txt file) can be made from the letters of another random word.
        //getting each letter the user has entered.
        for letter in word{
            if let pos = tempword.firstIndex(of: letter){
                tempword.remove(at: pos)
            }else{
                return false
            }
        }
        
        return true
        }
    
    //checking our string for mispelled words.

    func isReal(word:  String) -> Bool{
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        //returns true if the word is correct and returns false if the word is mispelled.
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    }
  


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
