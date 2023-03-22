//
//  TheaterButtonCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/19.
//

import UIKit

class TheaterButtonCell: UITableViewCell {
    
    let theaterButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTheaterButton()
        
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TheaterButtonCell {
    func setupTheaterButton() {
        
//        let backgroundColor = UIColor(rgb: 0x7b9acc)
//        let titleColor = UIColor(rgb: 0xFCF6F5)
        
        theaterButton.setTitle("상영 영화관 보러가기", for: .normal)
//        theaterButton.setTitleColor(titleColor, for: .normal)
        theaterButton.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 18)
//        theaterButton.backgroundColor = backgroundColor
        theaterButton.layer.cornerRadius = 5
        theaterButton.layer.shadowOffset = CGSizeMake(0, 0)
        theaterButton.layer.shadowColor = UIColor.black.cgColor
        theaterButton.layer.shadowOpacity = 0.23
        
        theaterButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(theaterButton)
        
        NSLayoutConstraint.activate([
            theaterButton.heightAnchor.constraint(equalToConstant: 50),
            theaterButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            theaterButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            theaterButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 90),
            theaterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90)
        ])
        
    }
}
