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
            if movieNm.count > 20 {
                cell.filmNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
            }
            
            // 국가 및 장르 라벨 생성
            let nations = nations.joined(separator: "/")
            let genres = genres.joined(separator: "/")
            let nationsGenres = nations + " \u{00B7} " + genres
            cell.nationsGenresLabel.text = nationsGenres
            
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
    
    func setupLabelColor(backgroundColor: UIColor?) -> UIColor {
        guard let backgroundColor = backgroundColor else { return UIColor.black }
        // 배경색의 밝기 계산
        var brightness: CGFloat = 0
        backgroundColor.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)

        // 밝기에 따라 텍스트 색상 설정
        let textColor = brightness > 0.5 ? UIColor.black : UIColor.white
        return textColor
    }
    
    func setupCells(cell: DetailCells, boxOfficeData: BoxOfficeModel?, filmIndexRow: Int, cellIndexPathRow: Int) -> DetailCells{
        if let directors = boxOfficeData?.boxOfficeResult[filmIndexRow].directors,
           let actors = boxOfficeData?.boxOfficeResult[filmIndexRow].actors,
           let synopsis = boxOfficeData?.boxOfficeResult[filmIndexRow].synopsis {
            let directors = directors.joined(separator: " \u{00B7} ")
            let actors = actors.joined(separator: " \u{00B7} ")
            
            if cellIndexPathRow == 3 {
                cell.titleLabel.text = "감독"
                cell.subtitleLabel.text = directors
            } else if cellIndexPathRow == 5 {
                cell.titleLabel.text = "배우"
                cell.subtitleLabel.text = actors
            } else if cellIndexPathRow == 7 {
                cell.titleLabel.text = "줄거리"
                cell.subtitleLabel.text = synopsis
            }
            cell.selectionStyle = .none
            cell.layer.shadowOffset = CGSizeMake(0, 0)
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOpacity = 0.1
        }
        return cell
    }
    
    //    func setupSubtitleCell(cell: DetailSubtitleCell, boxOfficeData: BoxOfficeModel?, filmIndexRow: Int, cellIndexPathRow: Int) -> DetailSubtitleCell {
    //
    //        if let directors = boxOfficeData?.boxOfficeResult[filmIndexRow].directors,
    //           let actors = boxOfficeData?.boxOfficeResult[filmIndexRow].actors,
    //           let synopsis = boxOfficeData?.boxOfficeResult[filmIndexRow].synopsis {
    //            let directors = directors.joined(separator: " \u{00B7} ")
    //            let actors = actors.joined(separator: " \u{00B7} ")
    //
    //            if cellIndexPathRow == 1 {
    //                cell.textLabel?.text = "감독"
    //                cell.detailTextLabel?.text = directors
    //            } else if cellIndexPathRow == 3 {
    //                cell.textLabel?.text = "배우"
    //                cell.detailTextLabel?.text = actors
    //            } else if cellIndexPathRow == 5 {
    //                cell.textLabel?.text = "줄거리"
    //                cell.detailTextLabel?.numberOfLines = 0
    //                cell.detailTextLabel?.text = synopsis
    //            }
    //            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    //            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
    //
    //            cell.selectionStyle = .none
    //            cell.layer.shadowOffset = CGSizeMake(0, 0)
    //            cell.layer.shadowColor = UIColor.black.cgColor
    //            cell.layer.shadowOpacity = 0.23
    //
    //            return cell
    //        }
    //        return DetailSubtitleCell()
    //    }
 
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, a: Int = 0xFF) {
          self.init(
              red: CGFloat(red) / 255.0,
              green: CGFloat(green) / 255.0,
              blue: CGFloat(blue) / 255.0,
              alpha: CGFloat(a) / 255.0
          )
      }
   
      convenience init(rgb: Int) {
             self.init(
                 red: (rgb >> 16) & 0xFF,
                 green: (rgb >> 8) & 0xFF,
                 blue: rgb & 0xFF
             )
         }
      
      // let's suppose alpha is the first component (ARGB)
    convenience init(argb: Int) {
        self.init(
            red: (argb >> 16) & 0xFF,
            green: (argb >> 8) & 0xFF,
            blue: argb & 0xFF,
            a: (argb >> 24) & 0xFF
        )
    }
}

