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
    
    var boxOfficeData: BoxOfficeModel?
    var filmIndexRow = 0 // mainViewController에서 넘어오는 indexPath.row
    var filmTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(DetailImageCell.self, forCellReuseIdentifier: "detailImageCell")
//        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backButtonImage = UIImage(named: "back_arrow")
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        detailTableView.separatorStyle = .none
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 100 {
            title = ""
        } else {
            title = filmTitle
        }
        if scrollView.contentOffset.y < 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1. 포스터, 제목. 2. 감독, 배우, 시놉시스. 3. 현재상영. 4. 상영예정
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = DetailImageCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            return setupCellsManager.setupImageCell(cell: cell, boxOfficeData: boxOfficeData, indexRow: filmIndexRow, appearance: appearance, navigationItem: self.navigationItem)

        case 1, 3, 5:
            let cell = DetailSubtitleCell()
            return setupCellsManager.setupSubtitleCell(cell: cell, boxOfficeData: boxOfficeData, filmIndexRow: filmIndexRow, cellIndexPathRow: indexPath.row)
            
        case 2, 4:
            let cell = SeparatorCell()
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 160

        case 1, 3, 5:
            return UITableView.automaticDimension
            
        case 2, 4:
            return 8

        default:
            return 50
        }
    }

}
