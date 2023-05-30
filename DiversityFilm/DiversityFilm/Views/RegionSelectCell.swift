//
//  RegionSelectCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/22.
//

import UIKit

final class RegionSelectCell: UITableViewCell {
    
    let regionLabel = UILabel()
    let checkImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 선택했을 때 회색 없애기
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        selectedBackgroundView = backgroundView
        
        separatorInset = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
        
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
        regionLabel.font = UIFont(name: "Pretendard-Regular", size: 17)
        contentView.addSubview(regionLabel)
        NSLayoutConstraint.activate([
            regionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            regionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            regionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
