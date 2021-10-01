//
//  MovieSimilar.swift
//  Desafio Mobile2You
//
//  Created by Eiki Yonemura on 01/10/21.
//

import Foundation

struct MovieSimilar: Codable{
    let results: [Results]
}

struct Results: Codable {
    let title:String
    let release_date: String
    let backdrop_path: String
    let genre_ids: [Int]
}
