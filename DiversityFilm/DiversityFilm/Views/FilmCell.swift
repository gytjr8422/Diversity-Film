//
//  FilmCell.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/07.
//

import UIKit

final class FilmCell: UICollectionViewCell {

    @IBOutlet weak var filmView: UIStackView!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var filmNameLabel: UILabel!
    
    let rankLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 0, height: 0))
    let activityIndicator = UIActivityIndicatorView()
    let newImageView = UIImageView()
    let labelView = UIView()
    let noImageLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cellWidth = self.frame.size.width
        
        contentView.layer.cornerRadius = contentView.frame.size.width / 20
        setupImageView(cellWidth: cellWidth)
        setupRankLabel(cellWidth: cellWidth)
    }
    
    func setupActivityIndicator() {
        activityIndicator.style = .medium
        activityIndicator.startAnimating()
        filmImageView.addSubview(activityIndicator)
        // 위치를 cell의 중앙으로 맞추기
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func setupImageView(cellWidth: CGFloat) {

        filmImageView.translatesAutoresizingMaskIntoConstraints = false
        filmNameLabel.translatesAutoresizingMaskIntoConstraints = false
        labelView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filmImageView)
//        contentView.addSubview(filmNameLabel)
        
        labelView.addSubview(filmNameLabel)
        contentView.addSubview(labelView)
        labelView.layer.cornerRadius = 5
        labelView.clipsToBounds = true
        
        let labelTopAnchor = filmImageView.bottomAnchor.constraint(equalTo: filmNameLabel.topAnchor, constant: -10)
        labelTopAnchor.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            filmImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            filmImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            filmImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            filmImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            labelTopAnchor,
            
            labelView.heightAnchor.constraint(equalToConstant: 50),
            labelView.topAnchor.constraint(equalTo: filmImageView.bottomAnchor, constant: 5),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            labelView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            labelView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            labelView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            filmNameLabel.centerYAnchor.constraint(equalTo: labelView.centerYAnchor),
            filmNameLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 5),
            filmNameLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -5),
            filmNameLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 10),
            filmNameLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -10)
        ])

        filmImageView.layer.cornerRadius = filmImageView.frame.size.height / 20
    }
    
    func setupNewImage(cellWidth: CGFloat) {
        newImageView.image = UIImage(named: "new-4")
        filmImageView.addSubview(newImageView)
        filmImageView.bringSubviewToFront(newImageView)
//        filmImageView.contentMode = .scaleAspectFill
        
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
//            newImageView.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: cellWidth * 0.05),
//            newImageView.trailingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: cellWidth * -0.05),
            newImageView.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: 15),
            newImageView.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor, constant: 15),
            newImageView.widthAnchor.constraint(equalToConstant: 55),
            newImageView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    
    private func setupRankLabel(cellWidth: CGFloat) {
        filmImageView.addSubview(rankLabel)
        rankLabel.textColor = .white
        rankLabel.layer.cornerRadius = cellWidth * 0.04
        rankLabel.layer.masksToBounds = true
        rankLabel.textAlignment = .center
        rankLabel.backgroundColor = .black.withAlphaComponent(0.5)
        rankLabel.frame.size.width = cellWidth * 0.23
        rankLabel.frame.size.height = cellWidth * 0.23
        rankLabel.font = UIFont.systemFont(ofSize: rankLabel.frame.size.width * 0.44)
        
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
//        rankLabel.leadingAnchor.constraint(equalTo: filmImageView.leadingAnchor, constant: 15).isActive = true
        rankLabel.topAnchor.constraint(equalTo: filmImageView.topAnchor, constant: 15).isActive = true
        rankLabel.trailingAnchor.constraint(equalTo: filmImageView.trailingAnchor, constant: -15).isActive = true
        rankLabel.widthAnchor.constraint(equalToConstant: cellWidth * 0.23).isActive = true
        rankLabel.heightAnchor.constraint(equalTo: rankLabel.widthAnchor).isActive = true
    }

    
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]), let outputImage = filter.outputImage else { return nil }
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        return UIColor(red: CGFloat(bitmap[0])/255.0, green: CGFloat(bitmap[1])/255.0, blue: CGFloat(bitmap[2])/255.0, alpha: CGFloat(bitmap[3])/255.0)
    }
}

