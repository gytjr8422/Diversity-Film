//
//  Constants.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/08.
//

import Foundation

struct K {
    static let cellNibIdentifier = "ReusableCell"
    static let cellNibName = "FilmCell"
    static let detailSegue = "showDetail"
    
    struct DetailCells {
        static let directorActorIdentifier = "DetailDirectorActorCell"
    }
    
    struct FStore {
        static let collectionName = "films"
    }
}
