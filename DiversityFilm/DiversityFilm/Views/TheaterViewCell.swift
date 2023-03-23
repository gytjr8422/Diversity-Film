//
//  TheaterViewCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/23.
//

import UIKit

class TheaterViewCell: UITableViewCell {
    
    let theaterLabel = UILabel()
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        theaterLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(theaterLabel)
        theaterLabel.font = UIFont(name: "Pretendard-Regular", size: 15)
        NSLayoutConstraint.activate([
            theaterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            theaterLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 30),
            theaterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            theaterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
