//
//  DetailFirstCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/15.
//

import UIKit

final class DetailImageCell: UITableViewCell {
    
    let filmImageView = UIImageView()
    let filmNameLabel = UILabel()
    let nationsGenresLabel = UILabel()
    let labelStackView = UIStackView()
    
    let setupCellsManager = SetupCellsManager()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupImageView()
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let imageViewHeight = filmImageView.frame.size.height
        let labelHeight = filmNameLabel.frame.size.height
        let cellHieght = imageViewHeight + labelHeight
        return CGSize(width: size.width, height: cellHieght)
    }
    
    func setupImageView() {
        
        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filmImageView)
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            filmImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            filmImageView.widthAnchor.constraint(equalToConstant: 80),
            filmImageView.heightAnchor.constraint(equalToConstant: 80 * 1.4)
        ])

    }
    
    func setupLabels() {
        filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        filmNameLabel.numberOfLines = 2
        
        nationsGenresLabel.translatesAutoresizingMaskIntoConstraints = false
        nationsGenresLabel.font = UIFont.systemFont(ofSize: 13)
        nationsGenresLabel.numberOfLines = 2
        
        labelStackView.axis = .vertical
        labelStackView.spacing = 3
        labelStackView.addArrangedSubview(filmNameLabel)
        labelStackView.addArrangedSubview(nationsGenresLabel)
        
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: filmImageView.centerYAnchor, constant: -12),
            labelStackView.leadingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
        ])
        
    }
    
    func imageViewCornerRadius() {
        filmImageView.clipsToBounds = true
        filmImageView.layer.cornerRadius = filmImageView.frame.size.height / 25
    }
    
    func configure(filmImage: UIImage) {
        DispatchQueue.main.async {
            self.filmImageView.image = filmImage
            
            let averageColor = self.filmImageView.image?.averageColor
            self.contentView.backgroundColor = averageColor
            let labelTextColor = self.setupCellsManager.setupLabelColor(backgroundColor: self.contentView.backgroundColor)
            self.filmNameLabel.textColor = labelTextColor
            self.nationsGenresLabel.textColor = labelTextColor
        }
    }
}
