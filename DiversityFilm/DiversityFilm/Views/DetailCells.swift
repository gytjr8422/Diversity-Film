//
//  DetailCells.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/19.
//

import UIKit

class DetailCells: UITableViewCell {
    
    let stackView = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DetailCells {
    func setupLabels() {
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        if let titleCustomFont = UIFont(name: "Pretendard-Bold", size: 17), let subCustomFont = UIFont(name: "Pretendard-Regular", size: 15) {
            titleLabel.font = titleCustomFont
            subtitleLabel.font = subCustomFont
        }
        subtitleLabel.isUserInteractionEnabled = true
        subtitleLabel.numberOfLines = 0
        
//        let attrString = NSMutableAttributedString(string: subtitleLabel.text!)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.lineSpacing = 4
//        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
//        subtitleLabel.attributedText = attrString
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.addSubview(titleLabel)
        stackView.addSubview(subtitleLabel)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -10),
            
            subtitleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}

