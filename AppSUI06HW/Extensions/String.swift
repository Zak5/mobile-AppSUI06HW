//
//  String.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 30.01.2022.
//

import Foundation
import NaturalLanguage

extension String {
    
    func tokenize() -> [String] {
        var tokens : [String] = []
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = self
        
        tokenizer.enumerateTokens(in: self.startIndex..<self.endIndex) { tokenRange, _ in
            tokens.append(String(self[tokenRange]).lowercased())
            return true
        }
        return tokens
    }
    
    func suffixArray(minLength: Int = 0) -> [(String, String)] {
        
        var suffixes: [(String, String)] = []
        
        let tokens = self.tokenize()
        
        for token in tokens {
            let sequence = SuffixSequence(string: token)
            for suffix in sequence {
                if minLength > 0 && suffix.count >= minLength {
                    suffixes.append((String(suffix), token))
                }
            }
        }
        
        return suffixes
    }
    
}

