//
//  DataModel.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/26.
//

import UIKit

struct NaverData: Codable {
    let items: [Items]
}

struct Items: Codable {
    let title: String
    let image: String
    let director: String
    let pubDate: String
    let actor: String
    let link: String
}
