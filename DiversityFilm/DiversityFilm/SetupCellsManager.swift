//
//  SetupCellsManager.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/17.
//

import UIKit

struct SetupCellsManager {
    
    func setupImageCell(cell: DetailImageCell, boxOfficeData: BoxOfficeModel?, indexRow: Int, appearance: UINavigationBarAppearance, navigationItem: UINavigationItem, image: UIImage?, backgroundColor: UIColor?, imageViewTextColor: UIColor?) -> DetailImageCell {

//        let loadImageManager = LoadImageManager()
        let boxOfficeResult = boxOfficeData?.boxOfficeResult[indexRow]
        
        if let movieNm = boxOfficeResult?.movieNm,
           let url = boxOfficeResult?.imgURL,
           let nations = boxOfficeResult?.nations,
           let genres = boxOfficeResult?.genres {
            cell.filmNameLabel.text = movieNm
            if movieNm.count > 20 {
                cell.filmNameLabel.font = UIFont(name: "Pretendard-Medium", size: 17)
            }
            
            // 국가 및 장르 라벨 생성
            let nations = nations.joined(separator: "/")
            let genres = genres.joined(separator: "/")
            let nationsGenres = nations + " \u{00B7} " + genres
            cell.nationsGenresLabel.text = nationsGenres
            
            if url == "https://kobis.or.kr/kobis/business/mast/mvie/findDiverMovList.do#" || image == nil {
                cell.imageViewCornerRadius()
                cell.contentView.backgroundColor = UIColor(rgb: 0x7b9acc)
                cell.filmNameLabel.textColor = UIColor(rgb: 0xFCF6F5)
                cell.nationsGenresLabel.textColor = UIColor(rgb: 0xFCF6F5)
                appearance.backgroundColor = UIColor(rgb: 0x7b9acc)
                appearance.shadowColor = .clear
                navigationItem.standardAppearance = appearance
                navigationItem.scrollEdgeAppearance = appearance
            } else {
                cell.contentView.backgroundColor = backgroundColor
                cell.filmNameLabel.textColor = imageViewTextColor
                cell.nationsGenresLabel.textColor = imageViewTextColor
                appearance.backgroundColor = backgroundColor
                appearance.shadowColor = .clear
                navigationItem.standardAppearance = appearance
                navigationItem.scrollEdgeAppearance = appearance
                
                cell.configure(filmImage: image)
                DispatchQueue.main.async {
                    // filmImageView의 크기가 정해지고 나서 cornerRadius를 줘야한다.
                    cell.imageViewCornerRadius()
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
            
            if let subTitleText = cell.subtitleLabel.text {
                let attrString = NSMutableAttributedString(string: subTitleText)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 4
                attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
                cell.subtitleLabel.attributedText = attrString
            }
        }
        return cell
    }
 
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

