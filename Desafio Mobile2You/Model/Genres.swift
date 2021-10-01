//
//  Genres.swift
//  Desafio Mobile2You
//
//  Created by Eiki Yonemura on 01/10/21.
//

import Foundation

struct Genres: Codable {
    let genres: [GenreId]
}

struct GenreId: Codable {
    let id: Int
    let name: String
}
