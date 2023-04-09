//
//  NoticeDetailViewController.swift
//  DiversityFilm
//
//  Created by 김효석 on 2023/03/24.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    let noticeDetailTableView = UITableView()
    var noticeTitle: String?
    var noticeSubtitle: String?
    var noticeContent: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear // 내비게이션 바 밑줄 없애기
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        
        self.noticeDetailTableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.noticeDetailTableView)
        NSLayoutConstraint.activate([
            self.noticeDetailTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.noticeDetailTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.noticeDetailTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.noticeDetailTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.noticeDetailTableView.dataSource = self
        self.noticeDetailTableView.separatorStyle = .none
        
        self.noticeDetailTableView.register(NoticeTitleCell.self, forCellReuseIdentifier: "noticeTitleCell")
        self.noticeDetailTableView.register(NoticeSeparatorCell.self, forCellReuseIdentifier: "noticeSeparatorCell")
        self.noticeDetailTableView.register(NoticeContentCell.self, forCellReuseIdentifier: "noticeContentCell")
    }
}

extension NoticeDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeTitleCell", for: indexPath) as! NoticeTitleCell
            cell.titleLabel.text = self.noticeTitle
            cell.subTitleLabel.text = self.noticeSubtitle
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeSeparatorCell", for: indexPath) as! NoticeSeparatorCell
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "noticeContentCell", for: indexPath) as! NoticeContentCell
            cell.contentLabel.text = self.noticeContent
            
            let attrString = NSMutableAttributedString(string: cell.contentLabel.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 7
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
            cell.contentLabel.attributedText = attrString
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    
}
