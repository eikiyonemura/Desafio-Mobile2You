//
//  Movie.swift
//  Desafio Mobile2You
//
//  Created by Eiki Yonemura on 01/10/21.
//

import Foundation

struct Movie: Codable {
    
    let original_title: String
    let popularity: Double
    let release_date: String
    let vote_count: Int
    let backdrop_path: String
    
}
