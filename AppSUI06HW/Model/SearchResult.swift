//
//  SearchResult.swift
//  AppSUI06HW
//
//  Created by Konstantin Zaharev on 31.01.2022.
//

import Foundation

struct SearchResult: Codable, Identifiable, Equatable {
    var id = UUID()
    let suffix: String
    let occurrences: Int
}
