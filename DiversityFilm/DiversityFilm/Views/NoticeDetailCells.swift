//
//  NoticeDetailCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/25.
//

import UIKit

final class NoticeTitleCell: UITableViewCell {
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.titleLabel.numberOfLines = 0
        self.subTitleLabel.numberOfLines = 0
        self.titleLabel.font = UIFont(name: "Pretendard-Bold", size: 20)
        self.subTitleLabel.font = UIFont(name: "Pretendard-Light", size: 14)
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.subTitleLabel)
        self.stackView.axis = .vertical
        self.stackView.spacing = 10
        
        self.contentView.addSubview(self.stackView)
        
        NSLayoutConstraint.activate([
            self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25),
            self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -25),
            self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.stackView.topAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
//            self.titleLabel.bottomAnchor.constraint(equalTo: self.subTitleLabel.topAnchor, constant: 10),
            
            self.subTitleLabel.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.subTitleLabel.bottomAnchor.constraint(equalTo: self.stackView.bottomAnchor),
            self.subTitleLabel.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NoticeSeparatorCell: UITableViewCell {
    
    let separatorView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.separatorView.backgroundColor = .lightGray
        self.selectionStyle = .none
        
        self.separatorView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            self.separatorView.heightAnchor.constraint(equalToConstant: 1),
            self.separatorView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.separatorView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.separatorView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            self.separatorView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class NoticeContentCell: UITableViewCell {
    
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        self.contentLabel.numberOfLines = 0
        self.contentLabel.font = UIFont(name: "Pretendard-Regular", size: 16)
        
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(contentLabel)
        NSLayoutConstraint.activate([
            self.contentLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            self.contentLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.contentLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            self.contentLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
