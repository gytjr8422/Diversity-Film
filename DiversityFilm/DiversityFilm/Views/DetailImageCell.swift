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
    
//    override func sizeThatFits(_ size: CGSize) -> CGSize {
//        let imageViewHeight = filmImageView.frame.size.height
//        let labelHeight = filmNameLabel.frame.size.height
//        let cellHieght = imageViewHeight + labelHeight
//        return CGSize(width: size.width, height: cellHieght)
//    }
    
    func setupImageView() {
        
        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filmImageView)
        NSLayoutConstraint.activate([
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            filmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25),
            filmImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25),
            filmImageView.widthAnchor.constraint(equalToConstant: 80),
            filmImageView.heightAnchor.constraint(equalToConstant: 80 * 1.4)
        ])

    }
    
    func setupLabels() {
        filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        filmNameLabel.font = UIFont(name: "Pretendard-Medium", size: 20)
        filmNameLabel.numberOfLines = 2
        
        nationsGenresLabel.translatesAutoresizingMaskIntoConstraints = false
        nationsGenresLabel.font = UIFont(name: "Pretendard-Regular", size: 14)
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
        filmImageView.layer.cornerRadius = filmImageView.frame.size.height / 20
    }
    
    func configure(filmImage: UIImage?) {
        DispatchQueue.main.async {
            self.filmImageView.image = filmImage
            
            // contentView의 아래쪽만 cornerRadius 주기
            let contentViewRect = self.contentView.bounds
            // layer.mask 속성에 적용할 마스크 레이어를 생성
            let maskLayer = CAShapeLayer()
            maskLayer.frame = contentViewRect
            maskLayer.path = UIBezierPath(roundedRect: contentViewRect,
                                          byRoundingCorners: [.bottomLeft, .bottomRight],
                                          cornerRadii: CGSize(width: 5, height: 5)).cgPath
            // contentView의 mask 속성에 마스크 레이어를 할당
            self.contentView.layer.mask = maskLayer
        }
    }
}
