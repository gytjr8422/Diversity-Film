//
//  NoticeCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/24.
//

import UIKit

class NoticeCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 선택했을 때 표시 모두 없애기
        self.selectionStyle = .none
        
        // 선택했을 때 회색 없애기
//        let backgroundView = UIView()
//        backgroundView.backgroundColor = .white
//        selectedBackgroundView = backgroundView
        
        self.titleLabel.numberOfLines = 2
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.font = UIFont(name: "Pretendard-Medium", size: 15)
        self.subTitleLabel.font = UIFont(name:"Pretendard-Light", size: 12)
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.subTitleLabel)
        stackView.spacing = 10
        stackView.axis = .vertical
        self.contentView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -15),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
//            self.titleLabel.bottomAnchor.constraint(equalTo: self.subTitleLabel.topAnchor, constant: -10),
            
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
