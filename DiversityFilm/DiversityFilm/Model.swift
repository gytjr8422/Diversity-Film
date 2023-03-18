//
//  Model.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/08.
//

import Foundation

struct BoxOfficeModel: Codable {
    let boxOfficeResult: [BoxOfficeResult]
}

struct BoxOfficeResult: Codable {
    let movieNm: String
    let rank: String
    let nations: [String]
    let genres: [String]
    let rankOldAndNew: String
    let directors: [String]
    let actors: [String]
    let imgURL: String
    let synopsis: String
    let current_theater: [String: [String]]
    let coming_theater: [String: [String]]
}
