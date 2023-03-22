//
//  RegionSelectCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/22.
//

import UIKit

class RegionSelectCell: UITableViewCell {
    
    let regionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        regionLabel.translatesAutoresizingMaskIntoConstraints = false
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
