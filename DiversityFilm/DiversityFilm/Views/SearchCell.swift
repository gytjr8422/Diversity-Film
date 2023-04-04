//
//  SearchCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/27.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    var filmNameLabel = UILabel()
    var filmImageView = UIImageView()
    var stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.stackView.spacing = 20
        self.stackView.axis = .horizontal
        
        self.filmImageView.layer.cornerRadius = 5
        
        self.filmNameLabel.font = UIFont(name: "Pretendard-Regular", size: 17)
        
        self.filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.filmImageView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(self.filmImageView)
        self.stackView.addArrangedSubview(self.filmNameLabel)
        self.contentView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.filmImageView.widthAnchor.constraint(equalToConstant: 50),
            self.filmImageView.heightAnchor.constraint(equalToConstant: 50 * 1.35),
            
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 35),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -35),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
