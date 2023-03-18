//
//  SetupCellsManager.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/17.
//

import UIKit

struct SetupCellsManager {
    
    func setupImageCell(cell: DetailImageCell, boxOfficeData: BoxOfficeModel?, indexRow: Int, appearance: UINavigationBarAppearance, navigationItem: UINavigationItem) -> DetailImageCell {
        
        let loadImageManager = LoadImageManager()
        let boxOfficeResult = boxOfficeData?.boxOfficeResult[indexRow]
        
        if let movieNm = boxOfficeResult?.movieNm,
           let url = boxOfficeResult?.imgURL,
           let nations = boxOfficeResult?.nations,
           let genres = boxOfficeResult?.genres {
            cell.filmNameLabel.text = movieNm
            cell.filmNameLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            // 국가 및 장르 라벨 생성
            let nations = nations.joined(separator: "/")
            let genres = genres.joined(separator: "/")
            let nationsGenres = nations + " \u{00B7} " + genres
            cell.nationsGenresLabel.text = nationsGenres
            cell.nationsGenresLabel.font = UIFont.systemFont(ofSize: 15)
            
            loadImageManager.loadImage(url: url) { image in
                guard let image = image else { return }
                cell.configure(filmImage: image)

                DispatchQueue.main.async {
                    // filmImageView의 크기가 정해지고 나서 cornerRadius를 줘야한다.
                    cell.imageViewCornerRadius()
                    appearance.backgroundColor = cell.contentView.backgroundColor
                    appearance.shadowColor = .clear
                    navigationItem.standardAppearance = appearance
                    navigationItem.scrollEdgeAppearance = appearance
                }
            }
            
        }
        return cell
    }
    
    func setupSubtitleCell(cell: DetailSubtitleCell, boxOfficeData: BoxOfficeModel?, filmIndexRow: Int, cellIndexPathRow: Int) -> DetailSubtitleCell {
        
        if let directors = boxOfficeData?.boxOfficeResult[filmIndexRow].directors,
           let actors = boxOfficeData?.boxOfficeResult[filmIndexRow].actors,
           let synopsis = boxOfficeData?.boxOfficeResult[filmIndexRow].synopsis {
            let directors = directors.joined(separator: " \u{00B7} ")
            let actors = actors.joined(separator: " \u{00B7} ")
            
            if cellIndexPathRow == 1 {
                cell.textLabel?.text = "감독"
                cell.detailTextLabel?.text = directors
            } else if cellIndexPathRow == 3 {
                cell.textLabel?.text = "배우"
                cell.detailTextLabel?.text = actors
            } else if cellIndexPathRow == 5 {
                cell.textLabel?.text = "줄거리"
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = synopsis
            }
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            cell.selectionStyle = .none
            cell.layer.shadowOffset = CGSizeMake(0, 0)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOpacity = 0.23

            return cell
        }
        return DetailSubtitleCell()
    }
    
    func setupLabelColor(backgroundColor: UIColor?) -> UIColor {
        guard let backgroundColor = backgroundColor else { return UIColor.black }
        // 배경색의 밝기 계산
        var brightness: CGFloat = 0
        backgroundColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)

        // 밝기에 따라 텍스트 색상 설정
        let textColor = brightness > 0.5 ? UIColor.black : UIColor.white
        return textColor
    }
}
