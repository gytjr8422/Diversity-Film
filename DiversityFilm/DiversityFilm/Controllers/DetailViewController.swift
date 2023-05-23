//
//  DetailViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/09.
//

import UIKit
import FirebaseFirestore

final class DetailViewController: UIViewController {
    @IBOutlet weak var detailTableView: UITableView!
    
    let loadImageManager = LoadImageManager()
    let setupCellsManager = SetupCellsManager()
    let detailImageCell = DetailImageCell()
    
    var boxOfficeData: BoxOfficeModel?
    var filmIndexRow = 0 // mainViewController에서 넘어오는 indexPath.row
    var filmTitle: String?
    var backgroundColor: UIColor?
    var imageViewTextColor: UIColor?
    var filmImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(DetailImageCell.self, forCellReuseIdentifier: "detailImageCell")
        
        // 다음 뷰컨트롤러의 내비게이션 back button 설정
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black  // 색상 변경
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        detailTableView.separatorStyle = .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 90 {
            title = ""
        } else {
            title = filmTitle
        }
        // 아래로 스크롤 안 되게 하기
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
    }                        

    @objc func buttonTapped() {
        let theaterViewController = TheaterViewController()
        navigationController?.pushViewController(theaterViewController, animated: true)
        theaterViewController.boxOfficeData = boxOfficeData
        theaterViewController.filmIndexRow = filmIndexRow
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = DetailImageCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            return setupCellsManager.setupImageCell(cell: cell, boxOfficeData: boxOfficeData, indexRow: filmIndexRow, appearance: appearance, navigationItem: self.navigationItem, image: filmImage, backgroundColor: backgroundColor, imageViewTextColor: imageViewTextColor)
        
        case 1:
            let cell = TheaterButtonCell()
            cell.theaterButton.setTitleColor(imageViewTextColor, for: .normal)
            cell.theaterButton.backgroundColor = backgroundColor
            cell.theaterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            return cell

        case 3, 5, 7:
            let cell = DetailCells()
            return setupCellsManager.setupCells(cell: cell, boxOfficeData: boxOfficeData, filmIndexRow: filmIndexRow, cellIndexPathRow: indexPath.row)
            
        case 2, 4, 6, 8:
            let cell = SeparatorCell()
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 3, 5, 7:
            return UITableView.automaticDimension
            
        case 2, 4, 6, 8:
            return 8

        default:
            return 50
        }
    }


}
